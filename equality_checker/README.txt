RWTHREE
Siddhartha Prasad

1. Overview
--------------
Rwthree is an equality checking system that, given a set of rewrite
rules, checks if two terms are equal in the specified system. It also provides
a verifiable certificate of the procedure used to determine equality.

SWI-Prolog are required required to use rwthree from the command line,
for use in a Prolog Shell, consult the Prolog Use Notes.

In the command line, the program can be used as follows:

	% sh rwthree [flags] rewrite_rules.pl input C1 C2

i. Rewrite rules must be represented in Prolog syntax in a file, as described
   in section 3.

ii. The input file should contain the two terms to be equated on seperate lines
	with the  (max) number of non-terminating rules to be used per term on
        the third line.

iii. The -t flag is used to provide input terms as trees. In this case, the number
     on non-terminating rules should not be provided.

iv. C1 and C2 are the proof certificates produced by the system.


2. Termination
--------------
It may be the case that certain rules (or pairs of rules) cause the system
to be non-terminating. For example, the pair of rules
		(a + b)*c -> (a*c) + (b*c)
		(a * b) + c -> (a + b) * (a + c)
	does not terminate.

The termination of a system of equations is, in general,
undecidable. Thus, in this case, the number of rules that do not terminate
must be provided to the program. 

3. Representing Rewrite Rules
--------------------------
Rules are specified as prolog predicates, and terms are represented as trees
of the form:
				t((OP,N), L)
			where OP is an operation,
				  N is the number of non-terminating rules
				  L is a list of the proper subterms of the current term

	If a term is a constant or variable, it is of the form
				t(x, [])
	Constants and variables can also be expressed as 'null-ary' operators
	of the form:
				t((OP, N), [])

	If constants are of the form (X,Y), they must be expressed as
	null-ary operators.

Terminating rules are expressed as follows:
	%Rule
	1 * X = X
	%rwthree representation.
	pred(t(('*', N), [t(1, []), X]), X).

Non terminating rules are expressed as follows:
	%Rule
	X + Y = Y + X
	%rwthree representation.
	pred( t(('+', N), [X, Y]), t(('+', N_), [Y, X])) :- N > 0, N_ is N-1.

Example files of rules can be found in the ExampleRules directory.


4. Building trees
--------------
rwthree allows the user the flexibility of providing terms in linear
mathematical notation or as trees.

The -t flag should be used when providing terms in tree form.


In order to express terms linearly the user
must also provide the program with a way to parse expressions into
and trees, named 'treeify'.

For instance, to parse the operator '+':

		treeify((X + Y), t((+, N), [X_, Y_]), N) :- treeify(X, X_, N),	
							    treeify(Y, Y_, N).
		treeify((X + Y), t((+, _), [X_, Y_])) :- treeify(X, X_),
							 treeify(Y, Y_).

		%If constants are treated as null-ary
		%operators
		treeify(X, t((X, N), []), N).
		treeify(X, t(X, _), []).	

		%If not nullary operators
	    	treeify(X, t(X,[]), _).
		treeify(X, t(X,[])).
