% coupling.pl
% Mathijs Saey
% This file contains the matching algorithm and the marriage management

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

% An incomplete matching is stable when
stableMatchingLoop(Marriages, Marriages, StabilityCheck) :- 
	% The current matchings are stable
	unAcceptable(_,_),
	checkMarriages(Marriages,StabilityCheck).

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