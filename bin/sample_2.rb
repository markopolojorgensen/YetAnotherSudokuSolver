require 'sudoku'

# puzzle from http://attractivechaos.github.io/plb/kudoku.html

Sudoku.do_sudoku DATA.read.split("\n")

__END__
1       2
 9 4   5 
  6   7  
 5 9 3   
    7    
   85  4 
7     6  
 3   9 8 
  2     1