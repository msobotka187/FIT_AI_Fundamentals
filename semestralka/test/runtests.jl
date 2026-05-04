using Test

using Sudoku.SudokuGenerator
using Sudoku.SudokuSolver

# Helper functions for testing
# Check if solved matrix meets the rules
function is_legal_solution(grid::Matrix{Int})
  s = size(grid, 1)
  b = round(Int, sqrt(s))

  # 1. Rows, cols check for uniqueness
  for i in 1:s
    if length(unique(grid[i, :])) != s return false end
    if length(unique(grid[:, i])) != s return false end
  end

  # 2. Block check
  for br in 0:(b-1), bc in 0:(b-1)
    # Takes the submatrix and puts it into a vector
    block = grid[(br*b + 1):(br*b + b), (bc*b + 1):(bc*b + b)]
    if length(unique(block)) != s return false end
  end

  return true
end

#-------------------------------------------------------
@testset "SudokuBoard Data Structure                   " begin
  # Square matrix
  @test_throws AssertionError SudokuBoard(zeros(Int, 9, 10))

  # Perfect square
  @test_throws AssertionError SudokuBoard(zeros(Int, 10, 10))

  # Valid size
  @test SudokuBoard(zeros(Int, 16, 16)).size == 16
end

#-------------------------------------------------------
@testset "Generator (Parameters & Edge Cases)          " begin
  # cells_empty out of range
  @test_throws AssertionError generate_puzzle(board_size=9, cells_empty=-5)
  @test_throws AssertionError generate_puzzle(board_size=9, cells_empty=100) # Max is 81

  # board_size not a perfect square
  @test_throws AssertionError generate_puzzle(board_size=10, cells_empty=20)

  # Fully solved board - should still pass
  full_board = generate_puzzle(board_size=9, cells_empty=0)
  @test count(==(0), full_board.grid) == 0
  @test is_legal_solution(full_board.grid) == true

  # Fully empty board - should still pass
  empty_board = generate_puzzle(board_size=9, cells_empty=81)
  @test count(==(0), empty_board.grid) == 81
end

#-------------------------------------------------------
@testset "Exact Solver (Correctness for different dims)" begin
  # Ranges for test
  dimensions = [4, 9, 16]

  for dim in dimensions
    empty_count = dim * 2
    board = generate_puzzle(board_size=dim, cells_empty=empty_count)
    solved_grid = sudoku_solver_ip(board)

    #-------------------------------------------------------
    @testset "Solution $dim x $dim                         " begin
      # Return a Size
      @test solved_grid !== nothing
      @test size(solved_grid) == (dim, dim)

      # Zeros a Range
      @test count(==(0), solved_grid) == 0
      @test all(x -> 1 <= x <= dim, solved_grid)

      # Is the sudoku legal?
      @test is_legal_solution(solved_grid) == true

      # Consistency test: Had solver overwritten the given number
      original_clues_match = true
      for r in 1:dim, c in 1:dim
        if board.grid[r, c] != 0 && board.grid[r, c] != solved_grid[r, c]
          original_clues_match = false
          break
        end
      end
      @test original_clues_match == true
    end
  end
end

#-------------------------------------------------------
@testset "Exact Solver - Unsolvable                    " begin
  broken_grid = zeros(Int, 9, 9)

  # Intentionally broken grid
  broken_grid[1, 1] = 5
  broken_grid[1, 2] = 5

  # Solver should return nothing
  broken_board = SudokuBoard(broken_grid)
  @test sudoku_solver_ip(broken_board) === nothing
end
