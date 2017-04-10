class Sudoku::Checker
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
    collisions = freqs(squares).select { |_, freq| freq > 1 }
    results << "collision: #{collisions.inspect}" unless collisions.empty?
    results
  end

  def check(puzzle)
    results = []
    unless puzzle.leftovers.empty?
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
