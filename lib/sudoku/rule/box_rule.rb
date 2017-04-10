module Sudoku
  module Rule
    # this square can't be the values other squares already have within the
    # same box
    class BoxRule
      include Common

      def apply(puzzle)
        results = []
        9.times do |box_i|
          squares = puzzle.box(box_i)
          squares.each do |square|
            init_square square
            next unless square.empty?

            squares.dup.reject(&:empty?).each do |valued_square|
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
end
