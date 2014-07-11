
treeify((X + Y), t((+, N), [X_, Y_]), N) :- treeify(X, X_, N), treeify(Y, Y_, N).
treeify((X * Y), t((*, N), [X_, Y_]), N) :- treeify(X, X_, N), treeify(Y, Y_, N).
treeify((- X), t((~, N), [X_]), N) :- treeify(X, X_, N).
treeify(X, t(X,[]), _).


treeify2((X + Y), t((+, _), [X_, Y_])) :- treeify2(X, X_), treeify2(Y, Y_).
treeify2((X * Y), t((*, _), [X_, Y_])) :- treeify2(X, X_), treeify2(Y, Y_).
treeify2((- X), t((~, _), [X_])) :- treeify2(X, X_).
treeify2(X, t(X,[])).


pred(t(('*', N), [t(1, []), X]), X).
pred(t(('*', N), [X, t(1,[])]), X).
%T
pred(t(('*', N), [t((~, N), [X]), X]), t(1,[])).
pred(t(('*', N), [X, t((~, N), [X])]), t(1,[])).

%Distribution laws
pred(t(('*', M), [X, t(('+', N), [Y, Z])]), t(('+', N), [t(('*', M), [X, Y]), t(('*', M), [X, Z])])).

%Commutativity
pred( t(('+', N), [X, Y]), t(('+', N_), [Y, X])) :- N > 0, N_ is N-1. 
pred( t(('*', N), [X, Y]), t(('*', N_), [Y, X])) :- N > 0, N_ is N-1.

%Associativity
pred(t(('*', N), [t(('*', M), [X, Y]), Z]), t(('*', N_), [X, t(('*', M), [Y, Z])])) :- N > 0, N_ is N-1.
pred( t(('*', N), [X, t(('*', M), [Y, Z])]), t(('*', N_), [t(('*', M), [X, Y]), Z])) :- N > 0, N_ is N-1.

pred(t(('+', N), [t(('+', M), [X, Y]), Z]), t(('+', N_), [X, t(('+', M), [Y, Z])])) :- N > 0, N_ is N-1.
pred( t(('+', N), [X, t(('+', M), [Y, Z])]), t(('+', N_), [t(('+', M), [X, Y]), Z])) :- N > 0, N_ is N-1.



