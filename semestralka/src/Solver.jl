module SudokuSolver
using JuMP
using HiGHS

export sudoku_solver_ip

function sudoku_solver_ip(board#=::SudokuBoard=#)
  return sudoku_solver_ip(board.grid)
end

function sudoku_solver_ip(grid::Matrix{Int})
  s = size(grid, 1)
  b = round(Int, sqrt(s))

  # Initialize the model with HiGHS optimizer
  model = Model(HiGHS.Optimizer)
  set_silent(model) # Silence the math console output

  # Variables:     x[r,   c,   v] is a binary variable
  @variable(model, x[1:s, 1:s, 1:s], Bin)

  # Constraints

  # 1. Every cell must have exactly ONE number
  for r in 1:s, c in 1:s
    @constraint(model, sum(x[r, c, v] for v in 1:s) == 1)
  end

  # 2. Every row must have exactly ONE of each number
  for r in 1:s, v in 1:s
    @constraint(model, sum(x[r, c, v] for c in 1:s) == 1)
  end

  # 3. Every col must have exactly ONE of each number
  for c in 1:s, v in 1:s
    @constraint(model, sum(x[r, c, v] for r in 1:s) == 1)
  end

  # 4. Every block must have exactly ONE of each number
  for br in 0:(b-1), bc in 0:(b-1), v in 1:s
    @constraint(model, sum(x[br*b + i, bc*b + j, v] for i in 1:b, j in 1:b) == 1)
  end

  # 5. Enforce prefilled numbers from generator
  for r in 1:s, c in 1:s
    if grid[r, c] != 0
      @constraint(model, x[r, c, grid[r, c]] == 1)
    end
  end

  # Let the model solve it
  optimize!(model)

  # Extract the solution back to the grid
  if termination_status(model) == MOI.OPTIMAL
    solved_grid = zeros(Int, s, s)
    for r in 1:s, c in 1:s, v in 1:s
      if value(x[r, c, v]) > 0.5
        solved_grid[r, c] = v
      end
    end # for r, c, v
    return solved_grid
  end # if

  println("No valid solution was found for this Sudoku.")
  return nothing
end # function sudoku_solver_ip
end # module SudokuSolver
