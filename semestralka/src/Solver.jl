module SudokuSolver

using JuMP
using HiGHS
using Random

export sudoku_solver_ip, generate_puzzle_ip

function sudoku_solver_ip(board#=::SudokuBoard=#)
  return sudoku_solver_ip(board.grid)
end

function sudoku_solver_ip(grid::Matrix{Int})
  s = size(grid, 1)
  b = round(Int, sqrt(s))

  # Initialize the model with HiGHS optimizer
  model = Model(HiGHS.Optimizer)
  set_silent(model) # Silence the math console output

  # Disable string names
  set_string_names_on_creation(model, false)

  # Variables:     x[r,   c,   v] is a binary variable
  @variable(model, x[1:s, 1:s, 1:s], Bin)

  # Constraints (vectorized)
  @constraint(model, [r=1:s, c=1:s], sum(x[r, c, v] for v in 1:s) == 1)
  @constraint(model, [r=1:s, v=1:s], sum(x[r, c, v] for c in 1:s) == 1)
  @constraint(model, [c=1:s, v=1:s], sum(x[r, c, v] for r in 1:s) == 1)
  @constraint(model, [br=0:(b-1), bc=0:(b-1), v=1:s], 
              sum(x[br*b + i, bc*b + j, v] for i in 1:b, j in 1:b) == 1)

  # 5. Enforce prefilled numbers from generator
  for r in 1:s, c in 1:s
    if grid[r, c] != 0
      fix(x[r, c, grid[r, c]], 1; force=true)
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

function generate_puzzle_ip(board_size::Int, cells_empty::Int)
  b = round(Int, sqrt(board_size))
  grid = zeros(Int, board_size, board_size)

  for i in 1:b
    start_row = (i - 1) * b + 1
    start_col = (i - 1) * b + 1
    nums = shuffle(1:board_size)
    idx = 1
    for r in start_row:(start_row + b - 1)
      for c in start_col:(start_col + b - 1)
        grid[r, c] = nums[idx]
        idx += 1
      end # for c
    end # for r
  end # for i

  solved_grid = sudoku_solver_ip(grid)

  if solved_grid === nothing
    error("IP solver nedokázal vygenerovat desku.")
  end

  cells_removed = 0
  while cells_removed < cells_empty
    r = rand(1:board_size)
    c = rand(1:board_size)
    if solved_grid[r, c] != 0
      solved_grid[r, c] = 0
      cells_removed += 1
    end # if
  end # while

  return solved_grid
end

end # module SudokuSolver
