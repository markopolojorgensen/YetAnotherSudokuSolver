module Sudoku::Rule
  # TODO: better name for this nonsense
  module Common
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

require 'sudoku/rule/row_col_rule'
require 'sudoku/rule/box_rule'
require 'sudoku/rule/box_one_rule'
