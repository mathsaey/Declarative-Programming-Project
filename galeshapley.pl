% galeshapley.pl
% Mathijs Saey
% This file contains the implementation of the gale shapley algorithm

%--------------------------%
% Amgorithm implementation %
%--------------------------%

% Algorithm
% ---------

galeShapley(Pred,M) :-
	Pred = man,
	OfferPred = women,
	createProposalList(man,P),
	galeShapleyIter(OfferPred,[],P, M).
	
galeShapley(Pred,M) :-
	Pred = women,
	OfferPred = man,
	createProposalList(women,P),
	galeShapleyIter(OfferPred,[],P, M).


galeShapleyIter(OfferPred,Marriages,Proposelist, Res) :-
	% Make a new empty offerlist
	createEmptyList(OfferPred,O),
	proposePhase(Marriages,O,NewOffers,Proposelist,NewProposeList),
	marriagePhase(Marriages,NewMarriages,NewOffers),

	% We stop when no new offers are made, 
	% this means that everybody is married
	((O = NewOffers, Res = NewMarriages,!);
	galeShapleyIter(OfferPred,NewMarriages,NewProposeList,Res),!).

% Propose phase
% -------------

% In the propose phase, every unmarried person offers to wed
% the person that is highest on his/her proposal list.
proposePhase(_,O,O,[],[]).
proposePhase(Marriages, OfferList, ResOfferList, [(X,Ls)|Tail],[(X,NewLs)|ResTail]) :- 
	proposePhase(Marriages, OfferList, NewOfferList, Tail,ResTail),
	% If the current person is not married
	\+ married(X,_,Marriages),
	% Get the person on the top of his list
	removeProposal(Ls,NewLs,Y),
	% Propose to that person
	addProposal(NewOfferList,ResOfferList,X,Y),!.

% If X is married then we ignore him
proposePhase(Marriages,OfferList, NewOfferList, [(X,Ls)|Tail],[(X,Ls)|ResTail]) :- 
	proposePhase(Marriages,OfferList,NewOfferList,Tail,ResTail),
	married(X,_,Marriages).

% Marriage phase
% --------------

marriagePhase(M,M,[]).

% Ignore X's without offers.
marriagePhase(Marriages,NewMarriages, [(_,[])|Tail]) :-
	marriagePhase(Marriages,NewMarriages,Tail).

% In the marriage phase every Y accepts the most
% tempting marriage offer.
marriagePhase(Marriages, ResMarriages, [(Y,Ls)|Tail]) :-
	married(Y,P,Marriages),
	marriagePhase(Marriages,NewMarriages,Tail),

	% If y is married we also include his/her partner
	choosePartner([P|Ls],Y,X),
	% Keep the marriages if Y stayed faithful
	((X = P, ResMarriages = Marriages) ; 
	% Otherwise delete the marriage and insert the new one
	(removeMarriage(Y,P,NewMarriages,RMarriages),
	 insertMarriage(Y,X,RMarriages,ResMarriages))),!.

marriagePhase(Marriages, ResMarriages, [(Y,Ls)|Tail]) :-
	marriagePhase(Marriages,NewMarriages,Tail),

	choosePartner(Ls,Y,X),
	insertMarriage(Y,X,NewMarriages,ResMarriages).


% A list of people propose to Y,
% Y picks the person he/she prefers most
choosePartner([X],_,X).
choosePartner([X|Tail],Y, NewPartner) :- 
	choosePartner(Tail,Y, Partner),
	rating(Y,X, R1),
	rating(Y,Partner, R2),
	((R1 >= R2, NewPartner = Partner);
	 (R1 < R2, NewPartner = X)),!.

%----------------%
% Offer Tracking %
%----------------%

% This section creates list that keep track of the proposals a person received.

createEmptyList(Pred,Res) :-
	bagof(X,call(Pred,X),B),
	zipLists(B,Res).

zipLists([],[]).
zipLists([L|T],[(L,[])|RT]) :- zipLists(T,RT). 	

addProposal([],[],_,_).
addProposal([(To,Ls)|Tail],[(To,[From|Ls])|Tail],From,To).
addProposal([X|Tail],[X|ResTail],From,To) :- addProposal(Tail,ResTail,From,To),!.

%-------------------%
% Proposal Tracking %
%-------------------%

% This section creates lists that keep track of who each X proposed to.

% Removes the first proposal from the list and returns it.
removeProposal([Head|Tail], Tail, Head).

% creation
%---------

% Generates the list for a single gender (depending on male or female optimal)
createProposalList(Pred,Res) :- 
	Pred = man,
	bagof(X,man(X),B),
	createProposalListLoop(B,Res,women),!.
createProposalList(Pred,Res) :- 
	Pred = women,
	bagof(X,women(X),B),
	createProposalListLoop(B,Res,man),!.

createProposalListLoop([],[],_).
createProposalListLoop([Head|Tail],[(Head,Ls)|ResTail],Pred) :- 
	createProposalListLoop(Tail,ResTail,Pred),
	createPersonProposalList(Head,Ls, Pred).

% Creates a list with all the possible proposals
% the proposals are sorted by rating.
createPersonProposalList(X,Res,Pred) :- 
	bagof(Y,call(Pred,Y),B),
	generateProposals(X,B,RatingList),
	insertSort(RatingList,SortedRatingList),
	removeRatings(SortedRatingList, Res),!.

% We generate a list of potential matches for X, with added rating.
generateProposals(_,[],[]). 
generateProposals(X,[Y|Tail],[(R,Y)|Res]) :- 
	generateProposals(X,Tail,Res),
	rating(X,Y,R).

% Remove ratings from the list after sorting
removeRatings([],[]).
removeRatings([(_,X)|Tail], [X|ResTail]) :- removeRatings(Tail,ResTail).