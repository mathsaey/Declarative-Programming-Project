% project.pl
% Mathijs Saey
% This file contains the stable-marriage algorithms
:-style_check(-discontiguous).

:- include(parser).

%---------%
% General %
%---------%

%Clause that calls the necessary parts of
%the program.
match(File,X) :- 
	removeParseData,
 	parseFile(File),
 	\+ containsTies,
 	stableMatching(X,isStableR),
 	printMarriages(X,isStableR).

matchTies(File,X,Y,Z) :-
	% Parse files
	removeParseData,
	parseFile(File),
	containsTies,

	% Calculate different stability types
	stableMatching(X,isSuperStableR),
	stableMatching(Y,isStrongStableR),
	stableMatching(Z,isWeakStableR),

	% Print the types
	write('Super stable: '), nl,
	printMarriages(X,isSuperStableR),
	write('Strong stable: '), nl,
	printMarriages(Y,isStrongStableR),
	write('Weak stable: '), nl,
	printMarriages(Z,isWeakStableR).

% Removes all the data from a parse
% from the database
removeParseData :- 
	(retract(man(_));
	 retract(women(_));
	 retract(rating(_,_,_)));
	true.

% Checks if there are ties present
containsTies :- rating(X,Y1,P),rating(X,Y2,P), Y1 \= Y2,!.

%--------------------%
% Generating couples %
%--------------------%

stableMatching(X,StabilityCheck) :- stableMatchingLoop([],X, StabilityCheck).

% A matching is stable when:
stableMatchingLoop(Marriages, Marriages, StabilityCheck) :- 
	% You cannot find a man or women that is not married to add
	(\+ (man(M), \+ married(M,_,Marriages));
	\+ (women(W), \+ married(W,_,Marriages))), 
	%And every marriage is stable
	checkMarriages(Marriages,StabilityCheck), !.

stableMatchingLoop(Marriages, Res, StabilityCheck) :- 
	% Get an unmarried man and women.
	man(M), \+ married(M,_,Marriages),
	women(W), \+ married(W,_,Marriages),

	% Add their marriage
	insertMarriage(M,W,Marriages,New),
	% And continue looking
	stableMatchingLoop(New,Res, StabilityCheck),
	% Remove this cut to only show one result 
	% This includes every possible matching in 
	% any possible order
	!.

%--------------------%
% Stability Checking %
%--------------------%

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

%---------------------%
% Marriage Management %
%---------------------%

% Add marriage
insertMarriage(Male,Female,Marriages,Marriages) :- married(Male,Female,Marriages), !.
insertMarriage(Male,Female,Marriages,[(Male,Female)|Marriages]).

% Remove marriage
removeMarriage(_,_,[],[]) :- !.
removeMarriage(Male, Female, [(Male,Female)|Rest], Res) :- !, removeMarriage(Male, Female, Rest, Res).
removeMarriage(Male, Female, [X|Tail], [X|ResTail]) 	:- removeMarriage(Male, Female, Tail, ResTail).

% Check if a marriage exists.
married(X,Y, [(X,Y)|_])		:- !.
married(X,Y, [(Y,X)|_])		:- !.
married(X,Y, [_|Marriages]) :- married(X,Y, Marriages).

%--------%
% Output %
%--------%

printMarriages(M, StabilityCheck) :- printMarriagesLoop(M,M,StabilityCheck).

printMarriagesLoop([],_,_).
printMarriagesLoop([(X,Y)|Tail], AllMarriages, StabilityCheck) :- 
	checkMarriage(X,Y,AllMarriages,StabilityCheck), !,
	write(X), write(' is happily married to: '), write(Y), nl,
	printMarriagesLoop(Tail,AllMarriages,StabilityCheck).
printMarriagesLoop([(X,Y)|Tail], AllMarriages,StabilityCheck) :- !,
	write(X), write(' is in an unstable relation with: '), write(Y), nl,
	printMarriagesLoop(Tail,AllMarriages,StabilityCheck).