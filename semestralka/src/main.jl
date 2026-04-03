include("Generator.jl")
include("Solver.jl")
include("Visualizer.jl")

using .SudokuGenerator
using .SudokuSolver
using .SudokuVisualizer

dim = 25
println("Generating ", dim, "x", dim, " puzzle...")
@time board = SudokuBoard(generate_puzzle_ip(25, 400))
print_board(board)

# println("Opening visualizer for Unsolved Board...")
# draw_board(board, "Unsolved 9x9 Sudoku")

# Pause so you can look at the unsolved board before it solves it
# println("Press Enter to solve...")
# readline()

println("Solving with Integer Programming...")
@time solved_grid = sudoku_solver_ip(board)
print_board(solved_grid)

# println("Opening visualizer for Solved Board...")
# draw_board(solved_grid, board, "Solved by IP (100% Guarantee)")

# Keep the window open at the end until you hit Enter again
# println("Press Enter to exit...")
# readline()
