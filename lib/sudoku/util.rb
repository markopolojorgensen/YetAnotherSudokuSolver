module Sudoku
  module Util
    # TODO needs a better name?
    #
    # takes multiple mult-line strings and combines them to be on the same
    # lines while preserving their internal newlines. Assumes individual
    # paragraphs are of consistent width and uniform height.
    def self.complect(*paragraphs)
      paragraphs.map! { |p| p.split("\n") }
      result = ''
      paragraphs.first.size.times do |i|
        result += paragraphs.map { |p| p[i] }.reduce(:+) + "\n"
      end
      result
    end

    def self.color_row(str, row, color)
      result = str.split("\n")
      result[row] = result[row].colorize(color)
      result.join("\n")
    end

    # FIXME: any row of text can't be colorized more than once =\
    def self.color_col(str, col, color)
      result = str.split("\n")
      result.size.times do |i|
        puts result[i].inspect
        puts result[i].size
        result[i][col] = result[i][col].colorize(color)
      end
      result.join("\n")
    end
  end
end
