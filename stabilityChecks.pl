% stabilityChecks.pl
% Mathijs Saey
% This file contains clauses that determine if a marriage is stable

%-------------------%
% Marriage stabilty %
%-------------------%

% Check if all the marriages are stable.
% the stability check determines which type of stable we test.
checkMarriages(Marriages, StabilityCheck) :- 
	checkMarriagesLoop(Marriages,Marriages,StabilityCheck).

% Loops over the marriages.
checkMarriagesLoop([],_,_).
checkMarriagesLoop([(Male,Female)|Tail], AllMarriages,StabilityCheck) :- 
	checkMarriage(Male,Female, AllMarriages, StabilityCheck), !,
	checkMarriagesLoop(Tail, AllMarriages, StabilityCheck).

% Checks if a given marriage is stable both ways.
checkMarriage(Male, Female, Marriages, StabilityCheck) :- 
	isStable(Male,Female,Marriages,StabilityCheck), 
	isStable(Female,Male,Marriages,StabilityCheck).

% Checks if a pair is stable
isStable(X,Y,Marriages,StabilityCheck) :-
	married(X,Y, Marriages),
	rating(X,Y, _),
	(man(X),bagof(W,women(W),B);
	 women(X),bagof(M,man(M),B)),
	checkPair(X,Y,B,Marriages,StabilityCheck),!.

% Checks pairs sees if there is a blocking pair for X.
checkPair(_,_,[],_,_).
checkPair(X,Y,[Head|Tail],Marriages, StabilityCheck) :- 
	married(Head,A,Marriages),
	checkPairs(X,Y,Head,A,StabilityCheck),
	checkPair(X,Y,Tail,Marriages,StabilityCheck),!.

% Checkpairs returns true if X,A is not a blocking pair.
checkPairs(X,_,A,_,_) :- X = A,!.
checkPairs(X,_,A,_,_) :- unAcceptable(X,A); unAcceptable(A,X),!.
checkPairs(X,Y,A,B,StabilityCheck) :- 
	rating(X,Y, RatingXY), rating(X,A, RatingXA),
	rating(A,X, RatingAX), rating(A,B, RatingAB),
	call(StabilityCheck, RatingXY, RatingAB, RatingXA, RatingAX),!.

% Returns true if X deems Y unAcceptable.
unAcceptable(X,Y) :- \+ (rating(X,Y,_)).

% Stability types
% ---------------

% We check for stability based on ratings, 
% (X,Y) and (A,B) are couple
% XY is the rating x gives to y,
% AB is the rating a gives to b,...

isStableR(XY,AB,XA,AX) :- isWeakStableR(XY,AB,XA,AX).

isWeakStableR(XY,AB,XA,AX) :-
	\+ (XY > XA,
		AB > AX).


isStrongStableR(XY,AB,XA,AX) :-
	\+ (XY > XA,
		AB >= AX).

isSuperStableR(XY,AB,XA,AX) :-
	\+ (XY >= XA,
		AB >= AX).