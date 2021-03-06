%Siddhartha Prasad
% 24 June 2014
t(_, _).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Given a final term, a rewrite certificate and and original term, this verifier
%recognizes if the rewrite procedure is valid.

verify(Tfinal, Certificate, Toriginal) :-  treeify(Tfinal, Rw),
   					   treeify(Toriginal, T),
					   onestep(Rw, Certificate, T).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If the current certificate is an empty list or a zero, the terms must be the
%same for the rewrites to be valid.

onestep(X, [], X). % Certificate is a list
onestep(X, 0, X).   %Certificate is an integer
onestep(X, S, X) :- number(S), S \= 0, write('In fewer steps').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%onestep(Rewritten formula, list of rewrites and paths, Term)
%If a list of rewrites (in order) and positions of terms are given,
%Each step is of the form:
onestep(Rw, [(Pred, Path)|Tail], T) :-  isList(Path),
					applyPred(Path, T, Pred, T_),
					catch(onestep(Rw, Tail, T_), _, fail).
 
 %And predicates are applied as:
 %Allows for using Tacticals
 applyPred([], Term, (Prop, Pred), T_) :- G=..[Prop, Pred, Term, T_], G.
 %Apply predicate on the term to be rewritten, ensuring it is of the proper form
 applyPred([], Term, Pred, T_) :-  Pred \= (_,_),
				   G=..[Pred, Term, T_], G.
 %Else, go to term to be rewritten
 applyPred([N|P_], t(K, L), Pred, t(K, Lnew)) :- listmem(N,L, X), applyPred(P_,X, Pred, Y), replace(N, Y,L, Lnew). 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%If only the number of rewrites is given, each step is of the form:
 %Where N is the number of rewrites left.
onestep(Rw, N, T) :- number(N), N > 0,
			applyPred(T, T_),
			N_ is N - 1,
			catch(onestep(Rw, N_, T_), E,
				(write(E),write('. Trying other options\n'), fail)).

%And predicates are applied as : applyPred(Term, rewritten term)								  
%Have reached the term to be rewritten, apply predicate
  applyPred(Term, T_) :- notList(Term),pred(Term, T_).
%Else, look at the children of the current term. Choose a child and apply a predicate to it.
 applyPred(t(K, L), t(K, Lnew)) :- member(X,L, N), applyPred(X, Y), replace(N,Y, L, Lnew). 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%If complete information is given about either the paths or predicate order,
%Each step is of the form:
onestep(Rw, [P|Tail], T) :- applyPred(P, T, T_),
				catch(onestep(Rw, Tail, T_), E,(write(E), 
				write('. Trying other options\n.'), fail)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%If only path given, it is assumed the predicates have the same name.
% and predicates are applied as follows:
%applyPred(Path to term, Term, rewritten term)		
						  
%Have reached the term to be rewritten, apply predicate
 applyPred([], Term, T_) :- pred(Term, T_).
%Else, go to term to be rewritten by looking at the children of the current term
applyPred([N|P_], t(K, L), t(K, Lnew)) :- listmem(N,L, X), applyPred(P_,X, Y), replace(N, Y,L, Lnew). 							  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%If only the order of predicates given
%Predicates are applied as follows:

%Allow for 'Tacticals' to be used
 applyPred((Prop, Pred), Term, T_) :- notList(Pred),G=..[Prop, Pred, Term, T_], G.
 %Predicate here must be an atom
 applyPred(Pred, Term, T_) :- atom(Pred),notList(Pred),
			      G=..[Pred, Term, T_], G.  
								
%Else, go to term to be rewritten, which could be in child of t(K, L) (member of L).
  applyPred(Pred, t(K, L), t(K, Lnew)) :- member(X,L, N), applyPred(Pred,X, Y), replace(N,Y, L, Lnew). 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Misc
 %checks if something is a list
 isList([_|X]) :- isList(X).
 isList([]).
 %Checks if X is not a list.
 notList(X) :- X \=[], X \=[Head|Tail].
 
 %member(Element, List, Index)
 member(X,[X|T], 0). 
 member(X,[H|T], N)  :-  member(X,T, N_), N is N_ + 1.
 
 %X is the Nth member of the list [_|T]
listmem(0, [H|T], H).
listmem(N, [_|T],X) :-  N0 is N-1,
						listmem(N0, T, X).

%replaces the Nth item in L with X
replace(0, X, [Y|Tail], [X|Tail]).
replace(N, X, [H|Tail], [H|Lnew]) :- N0 is N-1,
						  replace(N0, X, Tail, Lnew).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Tacticals
 
 %Allows for a predicate to be made symmetric
 sym( Pred, T, S) :- G=..[Pred, T, S],G.
 sym(Pred, T, S) :-  G=..[Pred, S, T], G. 

%Allows for a converse relation
conv(Pred, T, S) :- G=..[Pred, S, T], G.

%Allows for Pred1(T,S)to be tried, and Pred2(T,S) if it doesn't work
else_((Pred1,Pred2), T, S) :- (G=..[Pred1,  T, S], G );(G=..[Pred2, T, S],G).

% Then, where you can include a path in Pred1 and Pred2, so that both can be run, and you need only go to a common ancestor to move to the next
%P1 and P2 are paths from common context
%Can also be used to simulate two in parallel if they are disjoint paths
then(((Pred1,P1),(Pred2,P2)),T,S) :- applyPred(P1, T, Pred1, T_), applyPred(P2, T_, Pred2, S).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
