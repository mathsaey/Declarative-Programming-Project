% project.pl
% Mathijs Saey
% This file contains the general code

:-style_check(-discontiguous).

:- include(parser). % Contains the parser + file reader
:- include(regret). % Contains the regret calculation and sorting
:- include(coupling). % Contains the code that manages marriages and mathces couples
:- include(stabilityChecks). % Contains the code that checks if marriages are stable

%--------%
% "Main" %
%--------%

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
 	printMarriages(X,isStableR), nl,
 	write('Couples: '), write(X), nl.

% Continues for a situation with ties.
matchCont :-
	containsTies,

	% Print the types
	write('Super stable: '), nl, super(X), nl,
	write('Strong stable: '), nl, strong(Y), nl,
	write('Weak stable: '), nl, weak(Z), nl, nl,

	write('Super stable list: '), write(X), nl,
	write('Strong stable list: '), write(Y), nl,
	write('Weak stable list: '), write(Z), nl,nl,!.

super(X) :-
	(stableMatching(X,isSuperStableR); true),
	printMarriages(X,isSuperStableR),
	true.

strong(X) :-
	(stableMatching(X,isStrongStableR); true),
	printMarriages(X,isStrongStableR),
	true.

weak(X) :-
	(stableMatching(X,isWeakStableR); true),
	printMarriages(X,isWeakStableR),
	true.

% Does the same thing as match but
% adds all marriages sorted by regret score afterwards
matchRegret(File) :- 
	match(File),
	regretResults(isStableR,X),
	printRegretList(X).

% Removes all the data from a parse
% from the database
removeParseData :- 
	retractall(man(_)),
	retractall(women(_)),
	retractall(rating(_,_,_)).

% Checks if there are ties present
containsTies :- rating(X,Y1,P),rating(X,Y2,P), Y1 \= Y2,!.


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