% Last modified: 8th July 2014
% Siddhartha Prasad

%This file includes some basic rules in
%propositional logic, with 'true' and 'false' as constants. '+' represents
%'OR', '*' represents 'AND'. '-' Represents negation in linear terms and
%'~' represents negation in trees.

treeify((X + Y), t((+, N), [X_, Y_]), N) :- treeify(X, X_, N), treeify(Y, Y_, N).
treeify((X * Y), t((*, N), [X_, Y_]), N) :- treeify(X, X_, N), treeify(Y, Y_, N).
treeify((- X), t((~, N), [X_]), N) :- treeify(X, X_, N).
treeify(X, t(X,[]), _).


treeify((X + Y), t((+, _), [X_, Y_])) :- treeify(X, X_), treeify(Y, Y_).
treeify((X * Y), t((*, _), [X_, Y_])) :- treeify(X, X_), treeify(Y, Y_).
treeify((- X), t((~, _), [X_])) :- treeify(X, X_).
treeify(X, t(X,[])).


pred( t(('+', N), [X, Y]), t(('+', N_), [Y, X])) :- N > 0, N_ is N-1. 
pred(t(('+', _), [X, t(false, [])]), X). 
pred(t(('+', _), [_, t(true, [])]), t(true, [])).
pred(t(('+', N), [t(('+', M), [X, Y]), Z]), t(('+', N_), [X, t(('+', M), [Y, Z])])) :- N > 0, N_ is N-1.
pred( t(('+', N), [X, t(('+', M), [Y, Z])]), t(('+', N_), [t(('+', M), [X, Y]), Z])) :- N > 0, N_ is N-1.

pred(t(('+', _),[X, t((~, _), [X])]), t(true,[])).
pred(t((~, _),[t((~, _),[X])]), X).

pred( t(('*', N), [X, Y]), t(('*', N_), [Y, X])) :- N > 0, N_ is N-1.

pred(t(('*', _), [_, t(false, [])]), t(false, [])).
pred(t(('*', _), [X, t(true, [])]), X).
pred(t(('*', N), [t(('*', M), [X, Y]), Z]), t(('*', N_), [X, t(('*', M), [Y, Z])])) :- N > 0, N_ is N-1.
pred( t(('*', N), [X, t(('*', M), [Y, Z])]), t(('*', N_), [t(('*', M), [X, Y]), Z])) :- N > 0, N_ is N-1.
pred(t(('*', _), [t((~, _), [X]), X]), t(false, [])).

pred(t(('*', _), [X, X]), X).
pred(t(('+', _), [X, X]), X).

pred(t(('*', M), [X, t(('+', N), [Y, Z])]), t(('+', N), [t(('*', M_), [X, Y]), t(('*', M_), [X, Z])])) :- M > 0, M_ is M-1.
pred(t(('+', M), [X, t(('*', N), [Y, Z])]), t(('*', N), [t(('+', M_), [X, Y]), t(('+', M_), [X, Z])])) :- M > 0, M_ is M-1.

pred(t((~, _), [t(('*', N), [X, Y])]), t(('+', N), [t((~, _),[X]),t((~, _),[Y])])).
pred(t((~, _), [t((+, N), [X, Y]) ]), t(('*', N), [t((~, _),[X]),t((~, _),[Y])])).

