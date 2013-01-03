% parser.pl
% Mathijs Saey
% This file contains the parser and the file reader

:- module(parser, [parseFile/1]).
:-style_check(-discontiguous).

% Redefine the > operator so that read accepts associative >
:-op(1,xfy,>).

% Opens the file and invokes the parser
parseFile(FileName) :- 
	open(FileName, read, Stream),
	read(Stream, Term), 
	parse(Term,Stream),
	close(Stream).

%-------------%
% Parse Logic %
%-------------%

%Parses the different possible inputs until we reach end of file
parse(end_of_file, _) 		:- !.
parse(man = {L}, Stream) 	:- convertArgList(L,X), addMen(X), ! , read(Stream,Term), parse(Term,Stream).
parse(women = {L}, Stream) 	:- convertArgList(L,X), addWomen(X), ! , read(Stream,Term), parse(Term,Stream).

parse(X : L, Stream) :- convertGTList(L,NewL), addPreferences(X,NewL,1), read(Stream,Term), parse(Term,Stream).

% Adds all the men/women in a list
addMen([]).
addWomen([]).
addMen([Head|Tail]) 	:- assert(man(Head)), addMen(Tail),!.
addWomen([Head|Tail]) 	:- assert(women(Head)), addWomen(Tail),!.

% Adds all the preferences to the database
addPreferences(_,[],_).
addPreferences(X, [[]|Tail],Ctr) 			:- NC is Ctr + 1, addPreferences(X,Tail, NC),!.
addPreferences(X, [[Head|Tail]|Rest],Ctr) 	:- assert(priority(X,Head,Ctr)), addPreferences(X,[Tail|Rest],Ctr),!.
addPreferences(X, [Head|Tail],Ctr)			:- assert(priority(X,Head,Ctr)), NC is Ctr + 1, addPreferences(X,Tail,NC),!.

%---------------%
% Extra Clauses %
%---------------%

% Takes an argument list (e.g. (a, b, c)) and converts it into an actual list [a,b,c]
convertArgList((Head,Rest), [Head|Tail]) :- convertArgList(Rest, Tail),!.
convertArgList(Head, [Head]).

%Takes a a>{b,c}>d string and converts it into a list
convertGTList({Head1,Head2} > Rest, [[Head1,Head2]|Tail]) 	:- convertGTList(Rest, Tail),!.
convertGTList(Head > Rest, [Head|Tail]) 					:- convertGTList(Rest, Tail),!.
convertGTList({X,Y},[[X,Y]])							 	:- !. 
convertGTList(X,[X]).