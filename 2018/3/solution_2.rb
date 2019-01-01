require 'pry'
def solution_2(input)
  matrix = Array.new(2_000) { Array.new(2_000) { 0 } }
  input.each do |line|
    p "input line: #{line}"
    x_start, y_start, width, height = get_dims(line)
    p "calling apply_cloth(#{x_start}, #{y_start}, #{width}, #{height})"
    # matrix = resize_matrix(matrix, x_start, y_start, width, height)
    matrix = apply_cloth(matrix, x_start, y_start, width, height)
  end
  p "matrix dims: #{matrix.length}x#{matrix.first.length}"

=begin
  uncomment to print out matrix like so:
  matrix.each { |x| puts x.join(" ") } # pretty print
  0 0 0 1
  0 0 0 0
  0 0 0 0
  0 0 0 0
=end

  count_overlaps(matrix)
end

def count_overlaps(matrix)
  counter = 0
  matrix.each do |row|
    row.each do |item|
      counter += 1 if item > 1
    end
  end
  puts counter
  counter
end

def apply_cloth(matrix, x_start, y_start, width, height)
  y_start.upto(y_start + height - 1) do |col_idx|
    x_start.upto(x_start + width - 1) do |row_idx|
      matrix[col_idx][row_idx] += 1
    end
  end
  matrix
end

def get_dims(line)
  #1 @ 1,3: 4x4
  #2 @ 3,1: 4x4
  #3 @ 5,5: 2x2
  left_top_delim_idx = line.index(",")
  at_symbol_idx = line.index("@")
  colon_idx = line.index(":")

  left = line[(at_symbol_idx + 2)...left_top_delim_idx]
  top  = line[(left_top_delim_idx + 1)...colon_idx]

  width_height_delim_idx = line.index("x")
  width  = line[(colon_idx+2)...width_height_delim_idx]
  height = line[(width_height_delim_idx + 1)..-1]

  [left, top, width, height].map(&:to_i)
end

def resize_matrix(matrix, x_start, y_start, width, height)
#   A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a rectangle 3 inches from the left edge, 2 inches from the top edge, 5 inches wide, and 4 inches tall. Visually, it claims the square inches of fabric represented by # (and ignores the square inches of fabric represented by .) in the diagram below:
#
# ...........
# ...........
# ...#####...
# ...#####...
# ...#####...
# ...#####...
# ...........
# ...........
# ...........

  num_rows_needed = x_start + height + 1 # basically assuming a 1x1 starting piece
  num_cols_needed = y_start + width  + 1

  num_mat_rows = matrix.length
  num_mat_cols = matrix.first.length

  num_rows_to_add = num_rows_needed - num_mat_rows
  num_cols_to_add = num_cols_needed - num_mat_cols

  add_rows(matrix, num_rows_to_add) if num_rows_to_add > 0
  add_cols(matrix, num_cols_to_add) if num_cols_to_add > 0

  matrix
end

def add_rows(matrix, num_rows_to_add=1)
  num_cols = matrix.first.length
  num_rows_to_add.times { |i| matrix << Array.new(num_cols) { 0 } }
  matrix
end

def add_cols(matrix, num_cols_to_add=1)
  matrix.each { |row| row.concat(Array.new(num_cols_to_add) { 0 }) }
end

file = File.readlines("./input.txt")
p solution_2(file)
