% project.pl
% Mathijs Saey
% This file contains the stable-marriage algorithms
:-style_check(-discontiguous).

:- include(parser).
:- include(stabilityChecks).

%---------%
% General %
%---------%

%Clause that calls the necessary parts of
%the program.
match(File) :- 
	removeParseData,
 	parseFile(File),
 	matchCont.

% Continues for a situation with no ties
matchCont :- 
	\+ containsTies,
 	stableMatching(X,isStableR),
 	printMarriages(X,isStableR),
 	write(X).

% Continues for a situation with ties.
matchCont :-
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
	printMarriages(Z,isWeakStableR),
	write('Super stable list: '), write(X), nl,
	write('Strong stable list: '), write(Y), nl,
	write('Weak stable list: '), write(Z), nl.

% Removes all the data from a parse
% from the database
removeParseData :- 
	retractall(man(_)),
	retractall(women(_)),
	retractall(rating(_,_,_)).

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
	stableMatchingLoop(New,Res, StabilityCheck)
	% Remove this cut to only show one result 
	% This includes every possible matching in 
	% any possible order
	.

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