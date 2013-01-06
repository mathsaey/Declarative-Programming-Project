#About

This is the project for the Declarative Programming course at the VUB. 
The goal of this project is to write a program that can find stable matchings for a given *stable marriage problem.*
The full explanation of the project can be found at: https://ai.vub.ac.be/node/1040 A brief version is presented below.

#Status

* Preprocessing step: √
* Own algorithm:
	* Basic preference lists: √
	* Tied preference lists: √
	* Incomplete preference lists: √
	* Male-optimal, Female-optimal, minimum-regret, regret scores: √
* Gale-Shapley algorithm: x
* Result output: √

#Assignment:


##Introduction

The stable marriage problem (SMP) is the problem of finding a stable matching between two sets of elements given a set of preferences for each element. A matching is a mapping from the elements of one set to the elements of the other set. A matching is stable whenever it is not the case that both:

1. Some given element A of the first matched set prefers some given element B of the second matched set over the element to which A is already matched, and
2. B also prefers A over the element to which B is already matched

The stable marriage problem is commonly stated as:

	Given n men and n women, where each person has ranked all members of the opposite sex with a unique number between 1 and n in order of preference, marry the men and women together such that there are no two people of opposite sex who would both rather have each other than their current partners. If there are no such people, all the marriages are "stable".


*Example 1 (2 pairs):*

man = {m1, m2}.
women = {w1, w2}.

Preferences:

m1: w1 > w2.   (this means: for man m1, w1 is prefered to w2)
m2: w1 > w2.
w1: m1 > m2.
w2: m1 > m2.
(We have a single stable matching:  {(m1, w1), (m2, w2)}).

 

*Example 2 (5 pairs):*

men  = {alan, barry, colin, dave, eric}.
women = {christine, tina, sarah, ruth, zoe}.

Preferences:

alan: christine > tina > zoe > ruth > sarah.
barry: zoe > christine > ruth > sarah > tina.
colin: christine > ruth > tina > sarah > zoe.
dave: zoe > ruth > christine > sarah > tina.
eric: christine > ruth > christine > sarah > tina.

zoe: eric > alan > dave > barry > colin.
christine: dave > eric > barry > alan > colin.
ruth: alan > dave > barry > colin > eric.
sarah: colin > barry > dave > alan > eric.
tina: dave > barry > colin > eric > alan.


**Each person’s preference list may be incomplete,** i.e. a person can exclude some members whom he/she does not want to be matched with. For example, alan does not want to be matched with ruth:

alan: christine > tina > zoe > sarah.

**There might be ties in preference lists;** namely, one can include two or more persons with the same preference in a tie. For example, if alan has no difference between tina and zoe:

alan: christine > {tina, zoe} > ruth > sarah.

Note that when ties in preference lists are present, there are three stability notations, namely super-stability, strong stability and weak-stability (Definitions in the Ref (Iwama and Miyazaki 2008)).

##Functional Requirements
Write a Prolog program that finds stable matchings for a given stable marriage problem. The preferences are given in a file written the above-mentioned format (some example files will be provided: 2pairs, 2pairs_incomplete_lists, 2pairs_with_ties, 5pairs).

* Preprocessing step: read from a given file the data about man and women’s preferences and transform them into a format appropriate for your program. (Hint: for a woman, her preference list can be transformed into a sequence of numbers, with the same number for men in tie. For example, m1 > {m2,m3} > m4 --> (m1,1), (m2,2), (m3,2), m4(3). If a man is not present in her preference list, declare him as unacceptable).
* Provide all possible stable matchings, allowing for incomplete preference lists and ties. In case of ties, provide stable matching for all the three definitions of stability (super, strong, weak).
* Provide, if any, the male-optimal, female-optimal, and minimum-regret stable matchings Definitions in the Ref (Iwama and Miyazaki 2008)). For the last case, rank all the stable matchings according to their regret scores.
* Implement the Gale-Shapley algorithm for finding male-optimal and female-optimal solutions for the stable marriage problem with complete lists of preferences, and without ties (Gale and Shapley 1962). Compare them with what you obtained in your first implementation.  What do you say about the efficiency?
* Output the results nicely, in human readable format.

##References:
Iwama, K. and S. Miyazaki (2008). A Survey of the Stable Marriage Problem and Its Variants. Proceedings of the International Conference on Informatics Education and Research for Knowledge-Circulating Society (icks 2008), IEEE Computer Society.

Gale, D. and Shapley, L. S. (1962): "College Admissions and the Stability of Marriage", American Mathematical Monthly, 69, 9-14.

 