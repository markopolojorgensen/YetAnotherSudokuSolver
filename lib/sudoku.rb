# require "sudoku/version"
# require 'pry'
require 'colorize'

module Sudoku
  class Checker
    def freqs(list)
      result = Hash.new(0)
      list.each do |item|
        result[item] += 1
      end
      result
    end

    def check_freqs(squares)
      results = []
      squares = squares.map { |sq| sq.empty? ? nil : sq.value }.compact
      collisions = freqs(squares).select { |k, v| v > 1 }
      if !collisions.empty?
        results << "collision: #{collisions.inspect}"
      end
      results
    end

    def check(puzzle)
      results = []
      if puzzle.leftovers.size != 0
        results << "missing #{puzzle.leftovers.size} squares"
      end
      9.times do |i|
        results += check_freqs(puzzle.row(i))
        results += check_freqs(puzzle.col(i))
        results += check_freqs(puzzle.box(i))
      end
      results << 'looks good!' if results.empty?
      results
    end
  end

  # data structure for accessing squares
  class Puzzle
    def initialize(lines)
      @lines = []
      lines.each do |line|
        @lines << line.split('').map { |s| Square.new(s) }
      end
    end

    def column_before(n)
      n % 3 == 0
    end

    def horiz_line
      " _________________ \n"
    end

    def to_s
      result = "--puzzle--\n"
      9.times do |row|
        result << horiz_line if row % 3 == 0
        line = @lines[row]
        9.times do |col|
          if column_before col
            result << '|'
          end
          square = line[col]
          if square.empty?
            result << '_'
          else
            if square.metadata[:found]
              result << square.value.to_s.green
            else
              result << square.value.to_s
            end
          end
          if !column_before(col + 1)
            result << ' '
          end
          result << '|' if col == 8
        end
        result << "\n"
        result << horiz_line if row == 8
      end
      result
    end

    def squares
      result = []
      @lines.each do |line|
        result += line
      end
      result
    end

    def row(i)
      @lines[i]
    end

    def col(i)
      result = []
      9.times do |j|
        result << @lines[j][i]
      end
      result
    end

    # 0 -> 00 01 02
    #      10 11 12
    #      20 21 22
    # 1 -> 03 04 05
    #      13 14 15
    #      23 24 25
    # 2 -> 06 07 08
    #      16 17 18
    #      26 27 28
    # row is floor(n/3)*3 + 0,1,2
    # col is n%3*3 + 0,1,2
    # 3 -> 30 31 32
    #      40 41 42
    #      50 51 52
    def box(n)
      result = []
      3.times do |i|
        row = (n.to_i / 3) * 3 + i
        # puts "row: #{n} -> #{row}"
        3.times do |j|
          col = (n % 3) * 3 + j
          # puts "  col: #{n} -> #{col}"
          result << @lines[row][col]
        end
      end
      result
    end

    # end ADS

    def leftovers
      squares.select { |sq| sq.empty? }
    end

    # find mystery values
    def iterate
      rules = []
      rules << RowColRule.new
      rules << BoxRule.new
      rules << BoxOneRule.new
      results = []
      loop_count = 0
      loop do
        puts self
        new_results = []
        rules.each do |rule|
          new_results += rule.apply(self)
        end
        loop_count += 1
        puts "end of loop #{loop_count}"
        puts new_results
        break if new_results.size == 0
      end
      results
    end
  end # Puzzle

  # TODO: better name for this nonsense
  module Common
    def init_square(square)
      if !square.empty?
        square.metadata[:possible_values] = [square.value]
      else
        square.metadata[:possible_values] ||= [1,2,3,4,5,6,7,8,9]
      end
    end

    def check_single_possibility(square)
      result = ''
      # FIXME duplicated code
      if square.metadata[:possible_values].size == 1
        square.value = square.metadata[:possible_values].first
        square.metadata[:found] = true
        result = "one option left: #{square.value}"
      end
      result
    end
  end

  # if this square is the only square in this box that can be x, it must be x
  # TODO: print a single box with all possibilities
  class BoxOneRule
    include Common

    def apply(puzzle)
      results = []
      9.times do |box_i|
        squares = puzzle.box(box_i)
        prohibited_nums = squares.select { |sq| !sq.empty? }.map { |sq| sq.value.to_i }
        # puts "nope: #{prohibited_nums.inspect}"
        9.times do |n|
          next if prohibited_nums.include? n
          candidates = squares.select { |sq| sq.empty? && sq.metadata[:possible_values].include?(n) }
          if candidates.size == 1
            results << "Only square in the box that can be #{n}"
            candidates.first.value = n
            candidates.first.metadata[:found] = true
          end
        end
      end
      results
    end
  end

  # this square can't be the values other squares already have
  class BoxRule
    include Common

    def apply(puzzle)
      results = []
      9.times do |box_i|
        squares = puzzle.box(box_i)
        squares.each do |square|
          init_square square

          if square.empty?
            squares.dup.select { |sq| !sq.empty? }.each do |valued_square|
              square.metadata[:possible_values].delete(valued_square.value)
            end

            check = check_single_possibility(square)
            results << check if !check.empty?
          end
          # puts square.metadata.inspect
        end
      end
      results
    end
  end

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
          square = puzzle.squares[(row*9) + col]
          init_square square

          if square.empty?
            puzzle.row(row).dup.select { |square| !square.empty? }.each do |valued_square|
              square.metadata[:possible_values].delete(valued_square.value)
            end

            puzzle.col(col).dup.select { |square| !square.empty? }.each do |valued_square|
              square.metadata[:possible_values].delete(valued_square.value)
            end

            check = check_single_possibility(square)
            results << check if !check.empty?
          end

          # puts square.metadata.inspect
        end
      end
      results
    end
  end

  # metadata about a location in a puzzle
  class Square
    attr_accessor :value, :metadata
    def initialize(value)
      @value = value.to_i
      @metadata = {}
    end

    def inspect
      @value.to_s
    end

    def empty?
      @value.nil? || @value == ' ' || @value == 0
    end
  end
end

lines = DATA.read.split("\n")
puzzle = Sudoku::Puzzle.new lines
results = puzzle.iterate
puts results
puts puzzle.leftovers.map(&:metadata)
puts Sudoku::Checker.new.check(puzzle)

__END__
    47 5
  93 5 6
2  9 8
  2  4 9
  68593
 4 1  8
   4 6  1
 6 7 24
 9 53