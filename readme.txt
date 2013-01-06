Use Guidelines
==============

In order to run this project, simply boot up swipl and open up the import file, you can achieve this with the following command [project].

There are 3 top level commands that will automatically parse a file, make a stable matching based on the preference lists in the file and print the result. These commands are listed below:

- match('path'). => Parses a file (incomplete preference lists and ties in preference lists are allowed), and matches it with the self created algorithm.
- matchWithRegret('path'). => Does the same as match('path'), after doing this it will also print a list with the stable matchings ordered by regret score. The regret score will only be calculated for weak stability in the case of ties in the preference lists.
- matchGS('path'). => Parses a file (incomplete preference lists and ties are not allowed) and uses the Gale-Shapley to match them, a male-optimal and female-optimale version are presented.

Example run
===========

Greyflood:source mathsaey$ swipl
Welcome to SWI-Prolog (Multi-threaded, 64 bits, Version 6.2.3)
Copyright (c) 1990-2012 University of Amsterdam, VU Amsterdam
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software,
and you are welcome to redistribute it under certain conditions.
Please visit http://www.swi-prolog.org for details.

For help, use ?- help(Topic). or ?- apropos(Word).

?- [project].
% project compiled 0.01 sec, 119 clauses
true.

?- matchGS('preffiles/5pairs.txt').
Male optimal solution: 

sarah is happily married to: barry
christine is happily married to: dave
ruth is happily married to: alan
tina is happily married to: colin
zoe is happily married to: eric
[ (sarah,barry), (christine,dave), (ruth,alan), (tina,colin), (zoe,eric)]

Female optimal solution: 

barry is happily married to: tina
alan is happily married to: ruth
colin is happily married to: sarah
dave is happily married to: christine
eric is happily married to: zoe
[ (barry,tina), (alan,ruth), (colin,sarah), (dave,christine), (eric,zoe)]
true ;

?- matchWithRegret('preffiles/5pairs.txt').
alan is happily married to: ruth
barry is happily married to: tina
colin is happily married to: sarah
dave is happily married to: christine
eric is happily married to: zoe

Couples: [ (alan,ruth), (barry,tina), (colin,sarah), (dave,christine), (eric,zoe)]
regretScore: 4, Marriages: [ (alan,ruth), (barry,sarah), (colin,tina), (dave,christine), (eric,zoe)]
regretScore: 5, Marriages: [ (alan,ruth), (barry,tina), (colin,sarah), (dave,christine), (eric,zoe)]
true ;
alan is happily married to: ruth
barry is happily married to: sarah
colin is happily married to: tina
dave is happily married to: christine
eric is happily married to: zoe

Couples: [ (alan,ruth), (barry,sarah), (colin,tina), (dave,christine), (eric,zoe)]
regretScore: 4, Marriages: [ (alan,ruth), (barry,sarah), (colin,tina), (dave,christine), (eric,zoe)]
regretScore: 5, Marriages: [ (alan,ruth), (barry,tina), (colin,sarah), (dave,christine), (eric,zoe)]
true ;

?- match('preffiles/2pairs_withties.txt').
Super stable: 

Strong stable: 

Weak stable: 
m1 is happily married to: w1
m2 is happily married to: w2


Super stable list: []
Strong stable list: []
Weak stable list: [ (m1,w1), (m2,w2)]

true.

?- match('preffiles/2pairs_incom.txt').
m1 is happily married to: w2
m2 is happily married to: w1

Couples: [ (m1,w2), (m2,w1)]
true ;