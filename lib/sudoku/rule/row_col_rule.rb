module Sudoku::Rule
  class RowColRule
    include Common

    def apply(puzzle)
      results = []
      9.times do |row|
        9.times do |col|
          # row 0, col 0 -> 0
          # row 0, col 1 -> 1
          # row 0, col 8 -> 8
          # row 1, col 0 -> 9
          square = puzzle.squares[(row * 9) + col]
          init_square square

          next unless square.empty?

          # TODO: row / col code duplication
          puzzle.row(row).dup.reject(&:empty?).each do |valued_square|
            square.metadata[:possible_values].delete(valued_square.value)
          end

          puzzle.col(col).dup.reject(&:empty?).each do |valued_square|
            square.metadata[:possible_values].delete(valued_square.value)
          end

          check = check_single_possibility(square)
          results << check unless check.empty?

          # puts square.metadata.inspect
        end
      end
      results
    end
  end
end
