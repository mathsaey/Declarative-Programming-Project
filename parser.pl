% parser.pl
% Mathijs Saey
% This file contains the parser and the file reader

%:- module(parser, [parseFile/1]).
:-style_check(-discontiguous).

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

% Adds all the men/women in a list
addMen([]).
addWomen([]).
addMen([Head|Tail]) 	:- assert(man(Head)), addMen(Tail),!.
addWomen([Head|Tail]) 	:- assert(women(Head)), addWomen(Tail),!.


%---------------%
% Extra Clauses %
%---------------%

% Takes an argument list (e.g. (a, b, c)) and converts it into an actual list [a,b,c]
convertArgList((Head,Rest), [Head | Tail]) :- convertArgList(Rest, Tail),!.
convertArgList(Head, [Head]).