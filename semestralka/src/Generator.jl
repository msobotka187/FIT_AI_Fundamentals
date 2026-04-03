module SudokuGenerator

using Random

export SudokuBoard, generate_puzzle, print_board

# Board datastructure
# N x N board, where N is a perfect square (e.g. 9x9, 16x16, 25x25)
struct SudokuBoard
  grid::Matrix{Int}
  size::Int
  block_size::Int

  function SudokuBoard(grid::Matrix)
    s::Int = size(grid, 1)
    b::Int = round(Int, sqrt(s))
    @assert s == b^2 "Board must be a perfect square (e.g. 9, 16, 25)"
    @assert size(grid, 1) == size(grid, 2) "Board must be square"
    new(grid, s, b)
  end # function SudokuBoard
end # struct SudokuBoard

# Validation logic
# Check if placing 'num' at (row, col) violates Sudoku rules
function is_safe(grid::Matrix{Int}, row::Int, col::Int, b::Int, num::Int)
  s::Int = size(grid, 1)

  # Check row and col
  for i::Int in 1:s
    if grid[row, i] == num || grid[i, col] == num
      return false
    end # if
  end # for

  # Check block
  start_row::Int = b * ((row - 1) ÷ b) + 1
  start_col::Int = b * ((col - 1) ÷ b) + 1

  for i::Int in 0:(b-1)
    for j::Int in 0:(b-1)
      if grid[start_row + i, start_col + j] == num
        return false
      end # if
    end # for j
  end # for i

  return true
end # function is_safe

# Randomized Backtracking to fill the board inplace
function fill_board!(grid::Matrix{Int}, b::Int)
  s::Int = size(grid, 1)
  for row::Int in 1:s
    for col::Int in 1:s
      if grid[row, col] == 0
        # Randomly shuffle numbers to ensure a random board
        nums = shuffle(1:s)
        for num in nums
          if is_safe(grid, row, col, b, num)
            grid[row, col] = num

            # Recursively try to fill the rest of the board
            if fill_board!(grid, b)
              return true
            end # if

            # If it leads to a dead end, backtrack
            grid[row, col] = 0
          end # if is_safe
        end # for num

        return false # Trigger backtracking
      end # if grid[row, cols] == 0
    end # for col in 1:s
  end # for row in 1:s

  return true # completely filled
end # funcion fill_board!

# The main generator
function generate_puzzle(; board_size::Int=9, empty_cells::Int=40)
  b::Int = round(Int, sqrt(board_size))
  @assert b^2 == board_size "Board is not a perfect square (e.g. 9, 16, 25)"

  # Create empty grid and fill it completely
  grid::Matrix{Int} = zeros(Int, board_size, board_size)
  fill_board!(grid, b)

  # Remove cells to create a puzzle
  cells_remove::Int = 0
  while cells_remove < empty_cells
    r::Int = rand(1:board_size)
    c::Int = rand(1:board_size)

    if grid[r, c] != 0
      grid[r, c] = 0
      cells_remove += 1
    end # if
  end # end while

  return SudokuBoard(grid)
end # funciton generate_puzzle

# Console board printing
function print_board(board::SudokuBoard)
  s::Int = board.size
  b::Int = board.block_size

  # Adjust padding for larger board where numbers > 9
  pad::Int = ndigits(s) + 1 # number of digits + 1
  dash_length::Int = (pad * s) + (b * 2) + 1

  println("-" ^ dash_length)

  for r::Int in 1:s
    print("| ")
    for c::Int in 1:s
      val = board.grid[r, c]
      # Print dots for empty cell, numbers otherwise
      str_val = val == 0 ? "." : string(val)
      print(rpad(str_val, pad - 1), " ")

      if c % b == 0
        print("| ")
      end # if c % b == 0
    end # for c
    println()

    if r % b == 0
      println("-" ^ dash_length)
    end # if r % b == 0
  end # for r
end # print_board

end # module  SudokuGenerator
