%Siddhartha Prasad
%18/7/2014
%This file allows for certificates to be written to stdout
%when rwthree is used from the command line.
createCert(Term, Cert, Rw) :- write(Term), write('\n'), write(Cert), 
			      write('\n'), write(Rw), write('\n').
