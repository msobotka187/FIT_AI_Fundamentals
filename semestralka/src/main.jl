include("Generator.jl")
include("Solver.jl")
include("SatSolver.jl")
include("Visualizer.jl")

using .SudokuGenerator
using .SudokuSolver
using .SatSolver
using .SudokuVisualizer

function run(dim::Int=9)
    println("Generating ", dim, "x", dim, " puzzle...")
    # Use your ILP generator, or write a dedicated faster one later
    board = SudokuBoard(generate_puzzle_ip(dim, round(Int, dim^2 * 0.65)))
    
    println("\nWhich solver do you want to use?")
    println("1. ILP (HiGHS)")
    println("2. SAT (DIMACS)")
    print("Choice: ")
    
    choice = readline()
    
    if choice == "1"
        println("Launching Visualizer with ILP Solver...")
        draw_interactive_board(board, sudoku_solver_ip)
    elseif choice == "2"
        println("Launching Visualizer with SAT Solver...")
        draw_interactive_board(board, sudoku_solver_sat)
    else
        println("Invalid choice. Exiting.")
        return
    end

    println("Press ENTER in the terminal to end program.")
    readline()
end