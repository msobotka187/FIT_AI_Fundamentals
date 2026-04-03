#!/usr/bin/env julia
include("Generator.jl")
include("Solver.jl")

using .SudokuGenerator
using .SudokuSolver

board = generate_puzzle(board_size=25, cells_empty=450)
println("9x9 Generated Sudoku Board")
print_board(board)

println("\nSolved by Integer Programming")
solved = sudoku_solver_ip(board)
print_board(solved)
