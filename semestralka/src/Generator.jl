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

# Helper function to find which block a row/col belongs to
@inline function get_block(r::Int, c::Int, b::Int)
  return b * ((r - 1) ÷ b) + ((c - 1) ÷ b) + 1
end # funciton get_block

# Fill the independant diagonal blocks randomly
function fill_diag_blocks!(grid::Matrix{Int}, s::Int, b::Int)
  for i in 1:b
    start_row = (i - 1) * b + 1
    start_col = (i - 1) * b + 1

    nums = shuffle(1:s)
    idx::Int = 1
    for r in start_row:(start_row + b - 1)
      for c in start_col:(start_col + b - 1)
        grid[r, c] = nums[idx]
        idx += 1
      end # for c
    end # for r
  end # for i
end # funciton fill_diag_blocks!

# Recursive solver using boolean state tracking
function solve_fast!(grid::Matrix{Int}, s::Int, b::Int, rows::BitMatrix, cols::BitMatrix, blocks::BitMatrix)
  # Find next empty cell
  r_empty, c_empty = 0, 0
  for r in 1:s
    for c in 1:s
      if grid[r, c] == 0
        r_empty, c_empty = r, c
        break
      end
    end # for c
  end # for r

  # If no empty cells are found, the board is solved
  if r_empty == 0
    return true
  end

  r, c, = r_empty, c_empty
  block = get_block(r, c, b)

  for num in 1:s
    # Checks legality of placing num
    if !rows[r, num] && !cols[c, num] && !blocks[block, num]
      grid[r, c] = num
      rows[r, num] = true
      cols[c, num] = true
      blocks[block, num] = true

      if solve_fast!(grid, s, b, rows, cols, blocks)
        return true
      end

      # Backtrack
      grid[r, c] = 0
      rows[r, num] = false
      cols[c, num] = false
      blocks[block, num] = false
    end # if !r && !c && !b
  end # for num

  return false
end # funciton solve_fast!

# The main generator function
function generate_puzzle(; board_size::Int=9, cells_empty::Int=45)
  b = round(Int, sqrt(board_size))
  grid = zeros(Int, board_size, board_size)

  # Prefil diagonal blocks
  fill_diag_blocks!(grid, board_size, b)

  # Setup state tracking matrices
  # First dim (row) what row/col/block are we in
  # Second dim (col) what numbers are there
  rows_used   = falses(board_size, board_size)
  cols_used   = falses(board_size, board_size)
  blocks_used = falses(board_size, board_size)

  # Register numbers we just placed in the diagonals
  for r in 1:board_size
    for c in 1:board_size
      val = grid[r, c]
      if val != 0
        rows_used[r, val] = true
        cols_used[c, val] = true
        blocks_used[get_block(r, c, b), val] = true
      end # if
    end # for c
  end # for r

  # Solve the rest
  solve_fast!(grid, board_size, b, rows_used, cols_used, blocks_used)

  # Make holes
  cells_removed = 0
  while cells_removed < cells_empty
    r = rand(1:board_size)
    c = rand(1:board_size)
    if grid[r, c] != 0
      grid[r, c] = 0
      cells_removed += 1
    end # if
  end # while

  return SudokuBoard(grid)
end # function generate_puzzle

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
