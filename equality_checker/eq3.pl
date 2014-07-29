% Term Rewriter
%7/8/2014 Siddhartha Prasad

t(_,_).

%Terms are provided in linear form
equal(T1, T2, N, Cert1, Cert2, Rw) :- treeify(T1, T1_, N), treeify(T2, T2_, N), 
				      equate(T1_, Norm, [], Cert1_), % Rewrite T1_ to normal form
				      treeify_uni(Norm, NormUni),   %Now convert the tree Norm into a unifiable tree NormUni
				      equate(T2_, NormUni, [], Cert2_), !,
				      reverse(Cert1, Cert1_), reverse(Cert2, Cert2_),
				      treeify(Rw, NormUni).
%Terms are provided as trees
equal(T1, T2, Cert1, Cert2, Rw) :- equate(T1, Norm, [], Cert1_), % Rewrite T1_ to normal form
				   treeify_uni(Norm, Rw), equate(T2, Rw, [], Cert2_),
		    		 reverse(Cert1, Cert1_), reverse(Cert2, Cert2_).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Either apply a rule to the Term and add the path (which is stored backwards),
%to the term
applyRule(T, T_, Path, Cert, [Path_|Cert]) :- pred(T, T_), reverse(Path_, Path).

%Else, try immediate subterms
applyRule(t(K1,L), t(K1, Lnew), Path, Cert, NewCert) :- member(SubT, L, N),
							Path_ = [N|Path],
							applyRule(SubT, SubT_, Path_, Cert, NewCert),
							replace(N, SubT_, L, Lnew).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If both terms are unifiable they are equal.
equate(Term, Term, C, C).
%Else, apply a rewrite rule somewhere in T1
equate(T1, T2, Cert, FinalCert) :- applyRule(T1, EqT1, [], Cert, NewCert),
				   equate(EqT1, T2, NewCert, FinalCert ).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%replaces the Nth item in L with X
replace(0, X, [_|Tail], [X|Tail]).
replace(N, X, [H|Tail], [H|Lnew]) :- N0 is N-1,
				     replace(N0, X, Tail, Lnew).
%X is the Nth member of [H|T]
member(X,[X|_], 0). 
member(X,[_|T], N)  :-  member(X,T, N_), N is N_ + 1.									
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Replaces all t(OP, L) with t((OP,_), L) to be unified with treeify pairs
treeify_uni(t(K,[]), t(K,[])) :- K \= (_,_).
treeify_uni(t((K, _), L), t((K, _), Lnew)) :- treeify_subterms_uni(L, Lnew, []).
treeify_subterms_uni(L, Lnew, Lprev) :- L = [X|Tail],
					treeify_uni(X, X_),
					treeify_subterms_uni(Tail, Lnew, [X_|Lprev]).
treeify_subterms_uni([], Y, X):- reverse(X, Y).				
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
