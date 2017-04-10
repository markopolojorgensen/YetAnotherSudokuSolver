module Sudoku
  # Rules are pieces of logic that actually help us get closer to a solution.
  # Usually they do this by ruling out possible values for a given square.
  module Rule
    # TODO: better name for this nonsense
    # Common logic between rules
    module Common
      # TODO: run this once for every square up front, not as part of every rule
      def init_square(square)
        if !square.empty?
          square.metadata[:possible_values] = [square.value]
        else
          square.metadata[:possible_values] ||= [1, 2, 3, 4, 5, 6, 7, 8, 9]
        end
      end

      def check_single_possibility(square)
        result = ''
        if square.metadata[:possible_values].size == 1
          square.value = square.metadata[:possible_values].first
          square.metadata[:found] = true
          result = "one option left: #{square.value}"
        end
        result
      end
    end
  end
end

require 'sudoku/rule/row_col_rule'
require 'sudoku/rule/box_rule'
require 'sudoku/rule/box_one_rule'
