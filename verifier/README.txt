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
	ii. The Certificate List, as described in section 3, must be on the
	    second line.
	iii. s must be on the third line of the file
	iv. Rewrite rules and tree-building rules must comprise the rest of
	    the certificate (See sections 4 and 5).

3. Certificate List and Tacticals
----------------------------------
The 'Certificate List' in the proof certificate contains the justifications
that an equality proof is indeed valid. The "checkpc" rewriter is flexible
in the Certificate Lists it accepts. Such a list could be:

	i. The rewrite rules used, in order.
	ii. The 'paths' from the root to the terms rewritten (in the tree 
	   structure described in section 4) in the order they were rewritten.
	iii. Some combination of i and ii.
	iv. The total number of rewrite rules used.

These are represented as Prolog lists. If the names of rewrite rules used are
not specified, they are assumed to be 'pred'.

A system of "tacticals" is also provided that allow for manipulation of
rewrite rules.

	- The "else" tactical attempts to apply a rewrite rule to a term.
	  If it fails, it attempts to apply another rule to the term.
	  Thus, if the two rules to be used are r1 and r2, (else, (r1,r2))
	  could be placed anywhere a rewrite rule could in the Certificate
	  List.

	- The "sym" tactical applies the symmetric version of a rewrite rule
	  to a term. Thus, if rule r1 is to be made symmetric, (sym, r1)
	  could be placed anywhere a rewrite rule could in the Certificate 
	  List.

	- The "conv" tactical applies the converse of a rewrite rule to a term.
	  Thus, if the converse of r1 is to be used, (conv, r1)
	  could be placed anywhere a rewrite rule could in the Certificate
	  List.

	- The "then" tactical takes two terms with a common 'ancestor' in
	the tree, and applies a rewrite rule to each without affecting
	anything higher in the tree than the common ancestor. Thus, if r1
	and r2 are the two rules and p1 and p2 are the paths to the two
	subterms, (then, (r1,p1),(r2,p2))) could be placed anywhere a rewrite
	rule could in the Certificate List.

These tacticals allow for greater flexibility for the user, and also reduce
the size of certificates required by the verifier.

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


6. Also Provided
------------------

- Example Certificates that use various features of "checkpc" can alss be found
in the directory '/Examples'. Additionally, the "rwthree" equality checker
can also be used to generate examples.

- A proof of correctness of the "checkpc" verifier

