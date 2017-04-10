require 'sudoku'

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