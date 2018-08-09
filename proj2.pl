%  Author   : Nam Nguyen
%  Origin   : Saturday Oct 7 2017
%  Purpose  : Finding solution for Math Puzzle, as described in project specs
% (rules are copied below)
%
%  A maths puzzle is a square grid of squares, each to be filled in with a single digit 1–9 (zero is
% not permitted) satisfying these constraints:
%   • each row and each column contains no repeated digits;
%   • all squares on the diagonal line from upper left to lower right contain the same value;
%       and
%   • the heading of reach row and column (leftmost square in a row and topmost square in
%       a column) holds either the sum or the product of all the digits in that row or column

% The aim is to be able to take list of lists as an mostly or totally unfilled puzzle
% with given headings and find a unique solution under time constraint 20s
% Original Puzzle can be of size 2x2, 3x3, or 4x4

% Load the clpfd & lists library
:- ensure_loaded(library(clpfd)).
:- use_module(library(lists)).

% Find solution for puzzle by satisfying constraints
puzzle_solution([Header|Rows]) :-
    % remove choice point here by using if-then-else with diagonal checking
    check_diagonal(Rows) ->
        % check each rows and cols of puzzle
        (maplist(check_row, Rows),
        Puzzle = [Header|Rows],
        transpose(Puzzle,Flipped),
        Flipped = [_|Cols],
        maplist(check_row, Cols)),
        % assign values to variables
        append(Rows, Vs),
        labeling([ff], Vs).


check_diagonal([First|Rest]) :-
    nth0(1, First, NumDiagonal), same_diagonal(1, NumDiagonal, Rest).

% check if all squares on diagonal line from upper left to lower right contain the same value
% recursively going through all rows, checking if number at Index of that row is the same as
% the one on leftmost corner.
same_diagonal(_, _, []).
same_diagonal(Index, NumDiagonal, [Row|Rest]) :-
    Index1 is Index + 1, nth0(Index1, Row, NumDiagonal),
        same_diagonal(Index1, NumDiagonal, Rest).

% check if a row is valid by checking for variables domain, whether 3rd rule is upheld
% and whether 1st rule is upheld.
check_row([]).
check_row([Header|Nums]) :-
    Nums ins 1..9,
    (prod_list(Nums, Header) ; sum_list1(Nums, Header)),
    all_distinct(Nums).

% find sum of elements in list
% use accumulator to optimise code with tail recursion
sum_list1(L,Sum) :-
sum_list1(L,0,Sum).

sum_list1([],Sum,Sum).
sum_list1([H|T],Accumulator,Sum) :-
    NewAccumulator #= Accumulator + H,
    sum_list1(T,NewAccumulator,Sum).

% find product of elements in list
% instantiate accumulator with 1
prod_list(L, Product) :- prod_list(L, 1, Product).

prod_list([],Product,Product).
prod_list([H|T], Accumulator, Product) :-
    NewAccumulator #= Accumulator * H,
    prod_list(T, NewAccumulator, Product).
