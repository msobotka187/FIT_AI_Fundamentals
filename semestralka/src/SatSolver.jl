module SatSolver

using z3_jll 

export sudoku_solver_sat

@inline function var_id(N::Int, x::Int, y::Int, z::Int)
    return (x - 1) * N^2 + (y - 1) * N + z
end

function sudoku_solver_sat(board)
    return sudoku_solver_sat(board.grid)
end

function sudoku_solver_sat(grid::Matrix{Int})
    N = size(grid, 1)
    b = round(Int, sqrt(N))
    num_vars = N^3

    io = IOBuffer()
    clauses = 0

    # clues
    for x in 1:N, y in 1:N
        if grid[x, y] > 0
            print(io, var_id(N, x, y, grid[x, y]), " 0\n")
            clauses += 1
        end
    end

    # minimal encoding
    # 1. At least one number in each entry
    for x in 1:N, y in 1:N
        for z in 1:N
            print(io, var_id(N, x, y, z), " ")
        end
        print(io, "0\n")
        clauses += 1
    end

    # 2. At most once per row
    for x in 1:N, z in 1:N
        for y1 in 1:(N-1), y2 in (y1+1):N
            print(io, "-", var_id(N, x, y1, z), " -", var_id(N, x, y2, z), " 0\n")
            clauses += 1
        end
    end

    # 3. At most once per col
    for y in 1:N, z in 1:N
        for x1 in 1:(N-1), x2 in (x1+1):N
            print(io, "-", var_id(N, x1, y, z), " -", var_id(N, x2, y, z), " 0\n")
            clauses += 1
        end
    end

    # 4. At most once per block
    for z in 1:N
        for i in 0:(b-1), j in 0:(b-1)
            cells = [(b*i + x, b*j + y) for x in 1:b for y in 1:b]
            for k1 in 1:(N-1), k2 in (k1+1):N 
                (x1, y1) = cells[k1]
                (x2, y2) = cells[k2]
                print(io, "-", var_id(N, x1, y1, z), " -", var_id(N, x2, y2, z), " 0\n")
                clauses += 1
            end
        end
    end

    # 5. At most one number per entry
    for x in 1:N, y in 1:N
        for z1 in 1:(N-1), z2 in (z1+1):N
            print(io, "-", var_id(N, x, y, z1), " -", var_id(N, x, y, z2), " 0\n")
            clauses += 1
        end
    end

    # 6. At least once per row
    for x in 1:N, z in 1:N
        for y in 1:N
            print(io, var_id(N, x, y, z), " ")
        end
        print(io, "0\n")
        clauses += 1
    end

    # 7. At least once per col
    for y in 1:N, z in 1:N
        for x in 1:N
            print(io, var_id(N, x, y, z), " ")
        end
        print(io, "0\n")
        clauses += 1
    end

    # 8. At least once per block
    for z in 1:N
        for i in 0:(b-1), j in 0:(b-1)
            for x in 1:b, y in 1:b
                print(io, var_id(N, b*i + x, b*j + y, z), " ")
            end
            print(io, "0\n")
            clauses += 1
        end
    end

    # write file andd run Z3
    
    cnf_data = take!(io)
    cnf_filename = "sudoku.cnf"
    err_filename = "z3_error.txt" # Capture the error stream!
    
    open(cnf_filename, "w") do f
        println(f, "p cnf $num_vars $clauses")
        write(f, cnf_data)
    end

    sol_filename = "solution.txt"

    # Execute Z3 with no breaking flags, and route errors to err_filename
    z3_jll.z3() do exe
        try
            run(pipeline(`$exe $cnf_filename`, stdout=sol_filename, stderr=err_filename))
        catch
        end
    end

    # parse dimacs result
    
    solved_grid = zeros(Int, N, N)
    is_sat = false

    if isfile(sol_filename)
        for line in eachline(sol_filename)
            clean_line = strip(line)
            
            # Z3 outputs standard DIMACS: "s SATISFIABLE"
            if startswith(clean_line, "s SATISFIABLE") || clean_line == "sat"
                is_sat = true
            elseif is_sat && startswith(clean_line, "v ")
                parts = split(clean_line)
                for i in 2:length(parts)
                    val_str = parts[parts[i] != "v" ? i : 2]
                    
                    if val_str == "0"
                        continue
                    end
                    
                    val = parse(Int, val_str)
                    
                    # Positive values mean the boolean variable is True
                    if val > 0 && val <= num_vars
                        v0 = val - 1
                        z = (v0 % N) + 1
                        y = (div(v0, N) % N) + 1
                        x = div(v0, N^2) + 1
                        
                        solved_grid[x, y] = z
                    end
                end
            end
        end
    end

    # Failsafe debugging to the terminal
    if !is_sat
        println("\n--- Z3 FAILED TO FIND A SOLUTION ---")
        if isfile(err_filename) && filesize(err_filename) > 0
            println("Z3 Error Log:")
            println(read(err_filename, String))
        elseif isfile(sol_filename) && filesize(sol_filename) > 0
            println("Z3 Standard Output:")
            println(read(sol_filename, String)[1:min(500, filesize(sol_filename))])
        else
            println("No output generated at all.")
        end
    end

    rm(cnf_filename, force=true)
    rm(sol_filename, force=true)
    rm(err_filename, force=true)

    return is_sat ? solved_grid : nothing
end

end # module SatSolver