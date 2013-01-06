% coupling.pl
% Mathijs Saey
% This file contains the matching algorithm and the marriage management

%--------------------%
% Generating couples %
%--------------------%

stableMatching(Marriages, StabilityCheck) :- 
	% Get a list of all men and women
	bagof(Men,man(Men),BM),
	bagof(Wom,women(Wom),BW),

	% Get every possible permutation
	permutation(BW,PW),

	% Merge one of these permutations with the men
	mergeCouples(BM,PW,Marriages),
	% See if this marriage is stable
	checkMarriages(Marriages,StabilityCheck).

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

% Merge a list of man and women
mergeCouples([],[],[]).
mergeCouples([MHead|MTail],[WHead|WTail], NewLs) :- mergeCouples(MTail,WTail,Ls), insertMarriage(MHead,WHead,Ls,NewLs).
