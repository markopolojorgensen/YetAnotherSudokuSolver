module Sudoku
  # data structure for accessing squares and storing/printing puzzle state
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
      "+-----------------+\n"
    end

    # TODO: print a single 3x3 box with all possibilities
    def to_s
      result = "--puzzle--\n"
      9.times do |row|
        result << horiz_line if row % 3 == 0
        line = @lines[row]
        9.times do |col|
          result << '|' if column_before col
          square = line[col]
          if square.empty?
            result << '_'
          elsif square.metadata[:found]
            result << square.value.to_s.green
          else
            result << square.value.to_s
          end
          result << ' ' unless column_before(col + 1)
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
      squares.select(&:empty?)
    end

    # find mystery values
    def iterate
      rules = []
      rules << Sudoku::Rule::RowColRule.new
      rules << Sudoku::Rule::BoxRule.new
      rules << Sudoku::Rule::BoxOneRule.new
      results = []
      loop_count = 0
      loop do
        puts
        puts self
        new_results = []
        rules.each do |rule|
          new_results += rule.apply(self)
        end
        puts new_results
        loop_count += 1
        puts "end of loop #{loop_count}"
        break if new_results.empty?
      end
      results
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
        @value.nil? || @value == ' ' || @value.zero?
      end
    end
  end
end
