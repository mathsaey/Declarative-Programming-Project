% galeshapley.pl
% Mathijs Saey
% This file contains the implementation of the gale shapley algorithm


% A list of people propose to Y,
% Y picks the person he/she prefers most
propose([X],_,X).
propose([X|Tail],Y, NewPartner) :- 
	propose(Tail,Y, Partner),
	rating(Y,X, R1),
	rating(Y,Partner, R2),
	((R1 >= R2, NewPartner = Partner);
	 (R1 < R2, NewPartner = X)),!.

%-------------------%
% Proposal Tracking %
%-------------------%

% This section creates lists that keep track of who each X proposed to.

% Generates the list for a single gender (depending on male or female optimal)
generateProposalList(Pred,Res) :- 
	Pred = man,
	bagof(X,man(X),B),
	generateProposalListLoop(B,Res,women),!.
generateProposalList(Pred,Res) :- 
	Pred = women,
	bagof(X,women(X),B),
	generateProposalListLoop(B,Res,man),!.

generateProposalListLoop([],[],_).
generateProposalListLoop([Head|Tail],[(Head,Ls)|ResTail],Pred) :- 
	generateProposalListLoop(Tail,ResTail,Pred),
	createProposalList(Head,Ls, Pred).

% We generate a list of potential matches for X, with added rating.
generateProposals(_,[],[]). 
generateProposals(X,[Y|Tail],[(R,Y)|Res]) :- 
	generateProposals(X,Tail,Res),
	rating(X,Y,R).

% Remove ratings from the list after sorting
removeRatings([],[]).
removeRatings([(_,X)|Tail], [X|ResTail]) :- removeRatings(Tail,ResTail).

% Creates a list with all the possible proposals
% the proposals are sorted by rating.
createProposalList(X,Res,Pred) :- 
	bagof(Y,call(Pred,Y),B),
	generateProposals(X,B,RatingList),
	insertSort(RatingList,SortedRatingList),
	removeRatings(SortedRatingList, Res),!.

% Removes the first proposal from the list and returns it.
removeProposal([Head|Tail], Tail, Head).

% Gets the first person that X has not proposed to yet.
getMatch(X,[(X,Ls)|Tail], [(X,NewLs)|Tail], Y) :- removeProposal(Ls,NewLs,Y).
getMatch(X,[Head|Tail], [Head|Tail], Y) :- getMatch(X,Tail,Tail,Y).
