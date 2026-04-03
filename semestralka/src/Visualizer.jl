module SudokuVisualizer

using GLMakie

export draw_board

# Unsolved
function draw_board(board, title_text::String="Sudoku Board")
  return _draw_core(board.grid, board.grid, title_text)
end

function draw_board(grid::Matrix{Int}, title_text::String="Sudoku Board")
  return _draw_core(grid, grid, title_text)
end

# Solved
function draw_board(solved_board, original_board, title_text::String="Solved Sudoku")
  grid_solved = typeof(solved_board)   <: Matrix ? solved_board   : solved_board.grid
  grid_orig   = typeof(original_board) <: Matrix ? original_board : original_board.grid

  return _draw_core(grid_solved, grid_orig, title_text)
end

# Actuall draw function
function _draw_core(grid::Matrix{Int}, original_grid::Matrix{Int}, title_text::String)
  s = size(grid, 1)
  b = round(Int, sqrt(s))

  fig = Figure(size=(1200, 1200))
  ax = Axis(fig[1, 1], title=title_text, aspect=DataAspect())

  hidedecorations!(ax)
  hidespines!(ax)

  # Draw sudoku lines
  for i in 0:s
    linewidth = (i % b == 0) ? 4.0 : 1.0
    color     = (i % b == 0) ? :black : :gray

    # Vertical lines
    lines!(ax, [i, i], [0, s], color=color, linewidth=linewidth)
    # Horizontal lines
    lines!(ax, [0, s], [i, i], color=color, linewidth=linewidth)
  end # for i

  # Draw numbers
  for r in 1:s
    for c in 1:s
      val = grid[r, c]
      if val != 0
        # Calculate center of cell
        x_pos = c - 0.5
        y_pos = (s - r) + 0.5

        # Dynamic font
        f_size = 96 / (ndigits(s) + 1)

        # Original numbers: black
        # Solved   numbers: blue
        text_color = (original_grid[r, c] == 0) ? :blue : :black

        text!(
              ax, string(val),
              position=(x_pos, y_pos),
              align=(:center, :center),
              fontsize=f_size,
              color=text_color
             )
      end # if val != 0
    end # for c
  end # for r

  # Open window
  display(fig)
  return fig
end # function _draw_core
end # module SudokuVisualizer
