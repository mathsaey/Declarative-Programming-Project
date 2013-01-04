:- include(parser).

%male(Men), female(X), priority(source, target, rating)

% Nakijken of huwelijk stabiel is
	% Man prefereert Y meer dan vrouw => als Y man prefeert boven man(Y) niet stabiel
% Huwelijk toevoegen
% Vorige Huwelijk verwijderen

%-----------------%
% Utility Clauses %
%-----------------%

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