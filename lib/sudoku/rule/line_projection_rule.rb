module Sudoku
  module Rule
    # The only squares in this box that can be x are in a line, therefore the
    # squares in the same line in other boxes cannot be x.
    class LineProjectionRule
      include Common

      def apply(puzzle)
        raise 'bwah' if puzzle.nil? # rubocop
        results = ["writeme: LineProjectionRule"]
        # 9.times do |box_i|
        #   squares = puzzle.box(box_i)
        #   prohibited_nums = squares.reject(&:empty?).map { |sq| sq.value.to_i }
        #   # puts "nope: #{prohibited_nums.inspect}"
        #   9.times do |n|
        #     n += 1 # 0-8 -> 1-9
        #     next if prohibited_nums.include? n

        #     candidates = squares.select do |sq|
        #       sq.empty? && sq.metadata[:possible_values].include?(n)
        #     end
        #     next unless candidates.size == 1

        #     results << "Only square in the box that can be #{n}"
        #     candidates.first.value = n
        #     candidates.first.metadata[:found] = true
        #   end
        # end
        results
      end
    end
  end
end
