module SudokuBenchmark

using BenchmarkTools
include("Generator.jl")
include("Solver.jl")

using .SudokuGenerator
using .SudokuSolver

export run_benchmarks

function run_benchmarks()
  println("==============================================")
  println("          SUDOKU PERFORMANCE BENCHMARK          ")
  println("==============================================")

  println("\n[1] Generator Benchmark (Time required to create a puzzle)")

  println("-> 9x9 (45 empty cells):")
  @btime generate_puzzle(board_size=9, cells_empty=45) samples=5 evals=1

  println("-> 16x16 (120 empty cells):")
  @btime generate_puzzle(board_size=16, cells_empty=120) samples=3 evals=1


  println("\n[2] IP Solver Benchmark (Time required to solve)")

  board9 = generate_puzzle(board_size=9, cells_empty=45)
  board16 = generate_puzzle(board_size=16, cells_empty=120)
  board25 = generate_puzzle(board_size=25, cells_empty=450)

  println("-> Solving 9x9:")
  @btime sudoku_solver_ip($board9) samples=3 evals=1

  println("-> Solving 16x16:")
  @btime sudoku_solver_ip($board16) samples=3 evals=1

  println("==============================================")
end # function run_benchmarks
end # module
