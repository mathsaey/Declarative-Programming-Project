% regret.pl
% Mathijs Saey
% This file contains the clauses that calculate regret and
% the clauses that sort results by regret.

%---------%
% General %
%---------%

% Gets the maximum of 2 integers
max(A,A,A).
max(A,B,A) :- A > B,!.
max(A,B,B) :- B > A,!.

% Gets the maxium of a list
maxList([M],M).
maxList([Head|Tail], Max) :- 
	maxList(Tail, M), 
	(Head >= M, Max = Head;
	 Head < M, Max = M),!.

% Adds the regret score to each marriage
addRegret([],[]).
addRegret([Head|Tail], [(R,Head)|ResTail]) :- regretScore(Head,R), addRegret(Tail,ResTail).

% Gathers all the stable marriages, adds the regret score,
% and sorts them by regret.
regretResults(StabilityCheck,Res) :-
	bagof(X,stableMatching(X,StabilityCheck),B),
	addRegret(B,R),
	insertSort(R,Res).

%--------------------%
% Regret calculation %
%--------------------%

regretScore(Marriages,X) :- regretList(Marriages,R), maxList(R,X).

regretList([],[]).
regretList([(X,Y)|Tail], [Regret|ResTail]) :- 
	rating(X,Y,P1),
	rating(Y,X,P2),
	max(P1,P2,Regret),
	regretList(Tail,ResTail),!.


%--------%
% Output %
%--------%

printRegretList([]).
printRegretList([(R,M)|Tail]) :- 
	write('regretScore: '), write(R), 
	write(', Marriages: '), write(M),nl, 
	printRegretList(Tail).
 
%---------%
% Sorting %
%---------%

% Insertion sort algorithm based on:
% http://ktiml.mff.cuni.cz/~bartak/prolog/sorting.html

insertSort(List,SortedList) :- insertSortLoop(List,[],SortedList),!.

insertSortLoop([],X,X).
insertSortLoop([Head|Tail],X,S) :- insert(Head,X,NewX), insertSortLoop(Tail,NewX,S).

insert((RI,MI),[(R,M)|Tail],[(R,M)|NewTail]) :- RI > R, insert((RI,MI), Tail,NewTail).
insert((RI,MI),[(R,M)|Tail],[(RI,MI),(R,M)|Tail]) :- RI =< R.
insert(X,[],[X]).