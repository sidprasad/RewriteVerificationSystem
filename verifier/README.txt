Rewrite Verifier
Siddhartha Prasad
----------------------
1. Overview
----------------------
The 'checkpc' verifier is a system that can, given a certificate of a proof
that two terms are equal, produce a larger proof and check its correctness.

It can be used on the command-line as follows:
		% sh checkpc proofcertificate.pc

2. Proof Certificates
----------------------
The proof certificates accepted by the verifier are flexible in their syntax
For an equality s = t, where the proof involves rewriting s to t:
	i. t must be on the first line of the proof certificate
	ii. The rewrite rules used, the terms rewritten, both or the number of
	    rewrite rules must be defined in a list on the second line of the
	    file, as described in section 3.
	iii. s must be on the third line of the file
	iv. Rewrite rules and tree-building rules must comprise the rest of
	    the certificate (See sections 4 and 5).

3. Certificate List
----------------------






4. Representing Rewrite Rules
------------------------------
Terms are represented in the system as trees of the form:
				t(OP, L)
		where OP is an operation,
		N is the number of non-terminating rules
		L is a list of the proper subterms of the current term

If a term is a constant or variable (say x), it is of the form
				t(x, [])
			
Rewrite rules are specified as predicates in Prolog syntax.
They are expressed as follows:

	<predicate name> (<initial term>, <resultant term>). 

For example, the rule	1 * X = X could be represented as:

	pred(t('*', [t(1, []), X]), X).

If the name of a rule is not explicitly mentioned in the 'Certificate List',
it, by default, assumed to be 'pred'.

5. Building trees
---------------------
'checkpc' allows the user to input terms in linear
mathematical notation. In order to express terms linearly the user
must also provide the program with a way to parse expressions into
and trees, in the form of Prolog predicates named 'treeify'.

For instance, to parse the operator '+':

	treeify((X + Y), t('+', [X_, Y_])) :- treeify(X, X_),
					    treeify(Y, Y_).
		
	%Constant case
	treeify(X, t(X,[])).

While the constant case needs to be expressed only once, a seperate
'treeify' predicate must be defined for each operator symbol.


6. Examples
---------------

Example Certificates that use various features of "checkpc" can alss be found
in the directory '/Examples'. Additionally, the "rwthree" equality checker
can also be used to generate examples.

