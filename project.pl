:- include(parser).

% Ik wil zoveel mogelijk unieke huwelijken, met nieuwe partners, die stabiel zijn


%----------------%
% Naive Solution %
%----------------%

% A matching is stable when:
stableMatching(Marriages) :- 
	% You cannot find a man or women that is not married to add
	(\+ (man(M), \+ married(M,_,Marriages));
	\+ (women(W), \+ married(W,_,Marriages))), 
	%And every marriage is stable
	checkMarriages(Marriages), !.

%% stableMatching(Marriages) :- 
%% 	% Get an unmarried man and women.
%% 	man(M), \+ married(M,_,Marriages),
%% 	women(W), \+ married(M,_,Marriages),

%% 	% Add their marriage
%% 	insertMarriage(M,W,Marriages,New),
%% 	% And continue looking
%% 	stableMatching(New).

%-----------------%
% Utility Clauses %
%-----------------%

% Check if all the marriages are stable.
checkMarriages(Marriages) :- checkMarriagesLoop(Marriages,Marriages).

% Loops over the marriages.
checkMarriagesLoop([],_).
checkMarriagesLoop([(Male,Female)|Tail], AllMarriages) :- 
	checkMarriage(Male,Female, AllMarriages), !,
	checkMarriagesLoop(Tail, AllMarriages).

% Checks if a given marriage is stable both ways.
checkMarriage(Male, Female, Marriages) :- isStable(Male,Female,Marriages), isStable(Female,Male,Marriages).

% Check if a marriage is stable, this check only works one way
% e.g. if you pose the query isStable(male,female, ls) then this will only
% check if the marriage is stable from the male point of view.
isStable(X,Y, Marriages) :-
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
	\+ (RatingXY > RatingXA, 
		RatingAB > RatingAX),!.

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
printMarriages(M) :- printMarriagesLoop(M,M).

printMarriagesLoop([],_).
printMarriagesLoop([(X,Y)|Tail], AllMarriages) :- 
	checkMarriage(X,Y,AllMarriages), !,
	write(X), write(' is happily married to: '), write(Y), nl,
	printMarriagesLoop(Tail,AllMarriages).
printMarriagesLoop([(X,Y)|Tail], AllMarriages) :- !,
	write(X), write(' is in an unstable relation with: '), write(Y), nl,
	printMarriagesLoop(Tail,AllMarriages).