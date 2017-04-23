require 'sudoku'

# '6 star' puzzle from saturday newspaper

puzzle = Sudoku.do_sudoku DATA.read.split("\n")
puts
puts puzzle.examine_boxes

# one = "123\n123\n123\n"
# two = "456\n456\n456\n"
# three = "789\n789\n789\n"
# puts Sudoku::Util.complect(one, two, three)
puts String.colors

# puts Sudoku::Util.color_row("111\n222\n333\n444\n555\n666\n777", 3, :green)

# test = "1111\n2222\n3333\n4444\n5555\n6666\n7777"
# test = Sudoku::Util.color_col(test, 1, :green)
# test = Sudoku::Util.color_col(test, 3, :green)
# puts test


__END__
   958 3 
         
  3 4 6  
 7     98
9   1   5
18     6 
  7 6 4  
         
 6 195   