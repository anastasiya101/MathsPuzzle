MathsPuzzle
A Maths Puzzle is an N * N grid that has headers in the first Row 
and first Column to which the corresponding Row or Column should 
either sum up to or is the product of. This program finds a solution 
to such Puzzle and prints false when no solution can be reached.

Constraint 1:
Each column and row solution contains no repeated digits.
The digits within the Puzzle have to be from 1 - 9, 
not including zero.

Constraint 2:
The same value must be placed in the diagonal,
from top left (1, 1) to bottom right (n, n) of the Puzzle.
First value in the Diagonal is 0 as it has no effect
on our Puzzle and isn't part of the header or solution.
        

Constraint 3:
The digits in each row and column either,
sum up to or give the product of the header

Satisfying these three criteria solves the Maths Puzzle and the
computer prints out the solution. Each proper Maths Puzzle 
only contains only one answer. False is printed if it not a 
valid Maths Puzzle and no digits satisfy the constriants.
