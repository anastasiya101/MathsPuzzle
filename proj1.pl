% Author: Anastasiya Bogoslovskaya <abogoslovska@student.unimelb.edu.au>
% Purpose: To solve a Maths Puzzle based on three main constraints.

% A Maths Puzzle is an N * N grid that has headers in the first Row
% and first Column to which the corresponding Row or Column should 
% either sum up to or is the product of. This program finds a solution 
% to such Puzzle and prints false when no solution can be reached.

% Example Puzzle:
% 
%      0 | 14 | 10 | 35
%     14 | __ | __ | __
%     15 | __ | __ | __
%     28 | __ | __ | __
%       

% Libraries used:
% constraint logic programming over finite domains helped transpose
% and find distinct values
% apply aided in applying predicates on the list
% list library for efficient and concise manipulation of lists

:- use_module(library(clpfd)).
:- use_module(library(apply)).
:- use_module(library(lists)).

% puzzle_solution/1 calls all the functions to meet the constraints to 
% solve. We call this with the Puzzle which is a list of lists containing
% headers and rows of the Puzzle.

puzzle_solution(Puzzle) :-
    
    % all digits are valid 1 - 9
    validDigits(Puzzle),

    % all of the solution digits are different in each row 
    allDistinct(Puzzle),
    
    % the diagonal digit is equal across the Puzzle
    populateDiagonals(Puzzle),
    
    % confirming constraint 3: sum or product of digits equal the header
    checkRows(Puzzle),
    
    % turning columns into rows to solve them
    transpose(Puzzle, TransposedPuzzle),
    
    % columns checked to satisfy constraint 3
    checkRows(TransposedPuzzle),
    
    % all of the solution digits are different in each column
    allDistinct(TransposedPuzzle),
    
    %grounding the terms for a valid solution
    groundPuzzle(Puzzle).


% Tackling Constraint 1:
% ------------------------
% validDigits/1 
%     Checking we have digits from 1 - 9, and

% allDistinct/1
%     Checking all values in Rows and Columns are not 
%     repeated for our solution.


% validDigits/1 takes the Puzzle, removes the Header Row and runs each Row
% into validDigit/1 which takes a Row, removes the Header of that Row in the
% first Column and checks each element is a valid number from 1 - 9.

validDigits([_Heading|Rows]):-
    maplist(validDigit,Rows).

%% validDigit([]).
validDigit([_Header|Row]) :-
    Row ins 1..9.


% allDistinct/1 takes the Puzzle, removes the Header Row and runs each Row
% into allDistinctDigits/1 which takes a Row, removes the Header of that Row
% in the first Column and checks that each element is different in that list

allDistinct([_Header|Rows]):-
    maplist(allDistinctDigits,Rows).

%% allDistinctDigits([]).
allDistinctDigits([_Header|Row]):-
    all_distinct(Row).



% Tackling Constraint 2:
% ------------------------
% populateDiagonals/1 
%     Putting the same value into the diagonal

% populateDiagonals/1 takes the Puzzle, removes the Header Row and calls 
% populateDiagonalDigit/1 which takes the remaining Rows goes through
% every row recursively, getting the position of the diagonal 
% by adding 1 to the index as we loop through the Rows. This holds
% when the DiagonalDigit value is the same across the diagonal.

populateDiagonals([_Header|Rows]):-
    populateDiagonal(1, Rows, DiagonalDigit).

populateDiagonal(_Index, [], _DiagonalDigit).
populateDiagonal(Index, [Row|Rows], DiagonalDigit):-
    nth0(Index, Row, DiagonalDigit),
    NextIndex is Index + 1,
    populateDiagonal(NextIndex, Rows, DiagonalDigit).


% Tackling Constraint 3:
% ----------------------
% checkRows/1
%     Checks that the digits in the Puzzle equal the sum or
%     product of that Rows Header.

% checkRow/1 : Sum Version
%     Checks that the sum of the row equals the Header.

% checkRow/1 : Product Version
%     Checks that the product of the row equals the Header.


% checkRows/1 takes the Puzzle, removes the header and checks every
% row in checkRow for sum or product by calling checkRow/1 

checkRows([_Header|Rows]) :-
    maplist(checkRow, Rows).

% uses sum to check if the Row(Tail of the list) is equal to the 
% Header(Head of the list).
checkRow([Header|Row]) :-
    % sum_list(Row, Header). - from lists library 
    sum(Row, #=, Header). % - from clpfd library


% calls rowProduct/2 which finds the product of the list 
% and holds if it is equal to the Header 
checkRow([Header|Row]):-
    rowProduct(Header, Row).

rowProduct(1,[]).
rowProduct(Header, [X|Xs]) :-
    rowProduct(Y, Xs),
    Header #= X * Y.       % Header is X * Y. | Header #= X * Y.


% Hint 5:
% choose the row with the smallest amount of options first to 
% optimize speed of program and have to process less combinations
% using bagof/3
% bagof( Template, Goal, Bag).


% Grounding the Solution:
% ------------------------
% groundPuzzle/1 takes the Puzzle, removes the header Row 
% and the Header of each subsequent Row and holds when every
% solution digit in that Row is grounded, thus resulting
% in the whole Puzzle's solution being grounded.

groundPuzzle([_Heading|Rows]) :-
    Rows = [_Header|Row],
    maplist(label, Row).

/*

groundPuzzle([_Heading|Rows]) :- 
    % Rows = [_Header|Row],
    maplist(groundTerm,Rows).

groundTerm([_Header|Row]):-
    ground(Row).
    
*/