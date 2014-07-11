%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Replaces all t(OP, L) with t((OP,M), L)
%treeify_pairs(t(K,[]), t(K,[]), _).
%treeify_pairs(t(K, L), t((K, M), Lnew), M) :- treeify_subterms(L, Lnew, [], M).
%treeify_subterms(L, Lnew, Lprev, M) :- L = [X|Tail],
%										treeify_pairs(X, X_, M),
%										treeify_subterms(Tail, Lnew, [X_|Lprev], M).
%treeify_subterms([], Y, X, _):- reverse(X, Y).		