:- include(parser).

%male(Men), female(X), rating(source, target, rating)

%-----------------%
% Utility Clauses %
%-----------------%

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
insertMarriage(Male,Female,Marriages,[(Male,Female)|Marriages]).

% Remove marriage
removeMarriage(_,_,[],[]) :- !.
removeMarriage(Male, Female, [(Male,Female)|Rest], Res) :- !, removeMarriage(Male, Female, Rest, Res).
removeMarriage(Male, Female, [X|Tail], [X|ResTail]) 	:- removeMarriage(Male, Female, Tail, ResTail).

% Check if a marriage exists.
married(X,Y, [(X,Y)|_])		:- !.
married(X,Y, [(Y,X)|_])		:- !.
married(X,Y, [_|Marriages]) :- married(X,Y, Marriages).