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
insertMarriage(X,Y,Marriages,Marriages) :- married(X,Y,Marriages), !.
insertMarriage(X,Y,Marriages,[(X,Y)|Marriages]).

% Remove marriage
removeMarriage(_,_,[],[]) :- !.
removeMarriage(X, Y, [(X,Y)|Rest], Res) :- !, removeMarriage(X, Y, Rest, Res).
removeMarriage(X, Y, [(Y,X)|Rest], Res) :- !, removeMarriage(X, Y, Rest, Res).
removeMarriage(X, Y, [A|Tail], [A|ResTail]) 	:- removeMarriage(X, Y, Tail, ResTail).

% Check if a marriage exists.
married(X,Y, [(X,Y)|_])		:- !.
married(X,Y, [(Y,X)|_])		:- !.
married(X,Y, [_|Marriages]) :- married(X,Y, Marriages).

% Merge a list of man and women
mergeCouples([],[],[]).
mergeCouples([MHead|MTail],[WHead|WTail], NewLs) :- mergeCouples(MTail,WTail,Ls), insertMarriage(MHead,WHead,Ls,NewLs).
