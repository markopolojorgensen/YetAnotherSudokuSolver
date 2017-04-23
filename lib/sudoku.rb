require 'colorize'

require 'sudoku/version'
require 'sudoku/util'
require 'sudoku/rule'
require 'sudoku/puzzle'
require 'sudoku/checker'

# Top level container module for gem
module Sudoku
  def self.do_sudoku(lines)
    puzzle = Puzzle.new lines
    results = puzzle.iterate
    puts results
    puts puzzle.leftovers.map(&:metadata)
    puts Checker.new.check(puzzle)
    puzzle
  end
end

# TODO: spec everything
# TODO: puzzle collection?
