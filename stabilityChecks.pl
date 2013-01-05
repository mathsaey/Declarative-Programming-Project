% stabilityChecks.pl
% Mathijs Saey
% This file contains clauses that determine if a marriage is stable


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

% Check if a marriage is stable, this check only works one way
% e.g. if you pose the query isStable(male,female, ls) then this will only
% check if the marriage is stable from the male point of view.
% The stability check is the kind of stability we need to test
isStable(X,Y, Marriages, StabilityCheck) :-
	married(X,Y, Marriages),
	% Get the rating of the pair
	% test fails here if X deems Y unnaceptable
	rating(X,Y, RatingXY),
	% Look up other possible matches for X
	rating(X,A, RatingXA), A \= Y,
	% See who the match (A) is maried to
	married(A,B, Marriages), 
	%Get the priorities that matter for A
	rating(A,X, RatingAX),
	rating(A,B, RatingAB),
	% Check if both partners of the
	% new pair would prefer each other
	% a lower rating means a higher interest
	call(StabilityCheck, RatingXY, RatingAB, RatingXA, RatingAX),!.

isStableR(XY,AB,XA,AX) :- isWeakStableR(XY,AB,XA,AX).

% Stability types for ties
% ------------------------

% We check for stability based on ratings, 
% (X,Y) and (A,B) are couple
% XY is the rating x gives to y,
% AB is the rating a gives to b,...

isWeakStableR(XY,AB,XA,AX) :-
	\+ (XA > XY,
		AX > AB).

isStrongStableR(XY,AB,XA,AX) :-
	\+ (XA > XY,
		AX >= AB).

isSuperStableR(XY,AB,XA,AX) :-
	\+ (XA >= XY,
		AX >= AB).
