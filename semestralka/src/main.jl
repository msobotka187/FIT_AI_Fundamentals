include("Generator.jl")
include("Solver.jl")
include("Visualizer.jl")

using .SudokuGenerator
using .SudokuSolver
using .SudokuVisualizer


dim = 16
println("Generating ", dim, "x", dim, " puzzle...")
board = SudokuBoard(generate_puzzle_ip(dim, round(Int, dim^2 * 0.65)))
draw_interactive_board(board, sudoku_solver_ip)

println("Press ENTER to end program")
readline()
