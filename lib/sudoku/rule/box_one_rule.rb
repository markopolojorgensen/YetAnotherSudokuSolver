module Sudoku
  module Rule
    # if this square is the only square in this box that can be x, it must be x
    class BoxOneRule
      include Common

      def apply(puzzle)
        results = []
        9.times do |box_i|
          squares = puzzle.box(box_i)
          prohibited_nums = squares.reject(&:empty?).map { |sq| sq.value.to_i }
          # puts "nope: #{prohibited_nums.inspect}"
          9.times do |n|
            next if prohibited_nums.include? n

            candidates = squares.select do |sq|
              sq.empty? && sq.metadata[:possible_values].include?(n)
            end
            next unless candidates.size == 1

            results << "Only square in the box that can be #{n}"
            candidates.first.value = n
            candidates.first.metadata[:found] = true
          end
        end
        results
      end
    end
  end
end
