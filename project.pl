:- include(parser).

%male(X), female(X), priority(source, target, rating)

% Nakijken of huwelijk stabiel is
	% Man prefereert Y meer dan vrouw => als Y man prefeert boven man(Y) niet stabiel
% Huwelijk toevoegen
% Vorige Huwelijk verwijderen

%-----------------%
% Utility Clauses %
%-----------------%

% Check if a marriage is stable
isStable(X,Y) :- 
	(married(X,Y) ; married(Y,X)).



% Add or remove marriages.
insertMarriage(X, Y) :- assert(married(X,Y)), assert(married(Y,X)).
removeMarriage(X, Y) :- retract(married(X,Y)), retract(married(Y,X)).