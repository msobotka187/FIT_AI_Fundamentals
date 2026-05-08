module SudokuGenerator

using Random

export SudokuBoard, generate_puzzle, print_board

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
  end
end

@inline function get_block(r::Int, c::Int, b::Int)
  return b * div(r - 1, b) + div(c - 1, b) + 1
end

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
      end
    end
  end
end

# Optimized Recursive solver using MRV (Minimum Remaining Values)
function solve_fast!(grid::Matrix{Int}, s::Int, b::Int, rows::BitMatrix, cols::BitMatrix, blocks::BitMatrix)
  r_empty, c_empty = 0, 0
  min_options = s + 1 # Start higher than max possible options

  # MRV Heuristic: Find the empty cell with the fewest valid moves
  for r in 1:s
    for c in 1:s
      if grid[r, c] == 0
        block = get_block(r, c, b)
        options = 0
        
        # Count how many legal numbers this specific cell can take
        for num in 1:s
          if !rows[r, num] && !cols[c, num] && !blocks[block, num]
            options += 1
          end
        end

        if options < min_options
          min_options = options
          r_empty = r
          c_empty = c
        end

        # Short-circuit logic:
        # If a cell has 0 options, the board is broken, stop searching.
        # If a cell has 1 option, pick it immediately.
        if min_options == 0 || min_options == 1
          break
        end
      end
    end
    if min_options == 0 || min_options == 1
      break
    end
  end

  # If we found an empty cell but it has 0 valid options, backtrack instantly
  if min_options == 0
    return false
  end

  # If no empty cells are found at all, the board is completely solved
  if r_empty == 0
    return true
  end

  r, c = r_empty, c_empty
  block = get_block(r, c, b)

  # Try the numbers randomly to ensure we don't generate the exact same puzzle structure
  for num in shuffle(1:s)
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
    end
  end

  return false
end

function generate_puzzle(; board_size::Int=9, cells_empty::Int=45)
  @assert board_size > 0 && isqrt(board_size)^2 == board_size "board_size is not a perfect square"
  @assert 0 <= cells_empty <= board_size^2 "cells_empty out of range"

  b = round(Int, sqrt(board_size))
  grid = zeros(Int, board_size, board_size)

  fill_diag_blocks!(grid, board_size, b)

  rows_used   = falses(board_size, board_size)
  cols_used   = falses(board_size, board_size)
  blocks_used = falses(board_size, board_size)

  for r in 1:board_size
    for c in 1:board_size
      val = grid[r, c]
      if val != 0
        rows_used[r, val] = true
        cols_used[c, val] = true
        blocks_used[get_block(r, c, b), val] = true
      end
    end
  end

  # Solve the rest to create a full valid board
  solve_fast!(grid, board_size, b, rows_used, cols_used, blocks_used)

  # Make holes
  cells_removed = 0
  while cells_removed < cells_empty
    r = rand(1:board_size)
    c = rand(1:board_size)
    if grid[r, c] != 0
      grid[r, c] = 0
      cells_removed += 1
    end
  end

  return SudokuBoard(grid)
end

function print_board(board::Matrix{Int})
  print_board(SudokuBoard(board))
end

function print_board(board::SudokuBoard)
  s::Int = board.size
  b::Int = board.block_size

  pad::Int = ndigits(s) + 1
  dash_length::Int = (pad * s) + (b * 2) + 1

  println("-" ^ dash_length)

  for r::Int in 1:s
    print("| ")
    for c::Int in 1:s
      val = board.grid[r, c]
      str_val = val == 0 ? "." : string(val)
      print(rpad(str_val, pad - 1), " ")

      if c % b == 0
        print("| ")
      end
    end
    println()

    if r % b == 0
      println("-" ^ dash_length)
    end
  end
end

end # module  SudokuGenerator