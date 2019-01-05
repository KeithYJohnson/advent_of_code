require 'pry'
require 'set'

def solution(
    input,
    matrix_contructor=method(:create_square_matrix_of_zeros),
    index_strategy=method(:count_claims_by_coord),
    output_counter=method(:count_overlaps)
)
  matrix = matrix_contructor.call
  input.each do |line|
    p "input line: #{line}"
    id, x_start, y_start, width, height = get_dims(line)
    p "calling index index_strategy with (#{x_start}, #{y_start}, #{width}, #{height}, #{id})"
    # matrix = resize_matrix(matrix, x_start, y_start, width, height)
    matrix = index_strategy.call(matrix, x_start, y_start, width, height, id)
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
  p "calling output_counter: #{output_counter}"
  output_counter.call(matrix)
end

def create_square_matrix_of_zeros(num_dims=2_000)
  Array.new(num_dims) { Array.new(num_dims) { 0 } }
end

def create_square_matrix_of_empty_arrays(num_dims=2_000)
  Array.new(num_dims) { Array.new(num_dims) { [] } }
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

def count_num_ids_with_no_overlap(matrix)
  all_ids      = Set.new
  with_overlap = Set.new

  matrix.each_with_index do |row, row_idx|
    p "row_idx: #{row_idx}"
    p "all_ids.length: #{all_ids.length}"
    p "with_overlap.length: #{with_overlap.length}"
    row.each do |item|
      as_set = item.to_set
      all_ids = all_ids | as_set
      with_overlap = with_overlap | as_set if item.length > 1
    end
  end
  p all_ids.difference(with_overlap).inspect
  all_ids.difference(with_overlap).length
end

def count_claims_by_coord(matrix, x_start, y_start, width, height, id)
  matrix.tap do |matrix|
    y_start.upto(y_start + height - 1) do |col_idx|
      x_start.upto(x_start + width - 1) do |row_idx|
        matrix[col_idx][row_idx] += 1
      end
    end
  end
end

def track_claim_ids_by_coord(matrix, x_start, y_start, width, height, id)
  matrix.tap do |matrix|
    y_start.upto(y_start + height - 1) do |col_idx|
      x_start.upto(x_start + width - 1) do |row_idx|
        matrix[col_idx][row_idx] << id
      end
    end
  end
end

def get_dims(line)
  #1 @ 1,3: 4x4
  #2 @ 3,1: 4x4
  #3 @ 5,5: 2x2
  left_top_delim_idx = line.index(",")
  at_symbol_idx = line.index("@")
  colon_idx = line.index(":")

  id = line[1...(at_symbol_idx - 1)].to_i

  left = line[(at_symbol_idx + 2)...left_top_delim_idx]
  top  = line[(left_top_delim_idx + 1)...colon_idx]

  width_height_delim_idx = line.index("x")
  width  = line[(colon_idx+2)...width_height_delim_idx]
  height = line[(width_height_delim_idx + 1)..-1]

  [id, left, top, width, height].map(&:to_i)
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
p solution(file, matrix_contructor=method(:create_square_matrix_of_empty_arrays),
    index_strategy=method(:track_claim_ids_by_coord),
    output_counter=method(:count_num_ids_with_no_overlap))
