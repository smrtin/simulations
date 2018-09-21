# simulations

in this repository some scripts are collected to perform various simulations from the field of biology

1) With the help of the Arena.pl we can test different competition strategies in a limited resource environment. A classical example from game theory. The 'competitors' are given information about their oponent and the results from the previous rounds to form their decision. They must return a 'yes' or 'no' for the Arena to place them.

Competitors are randomly chosen from a pool of competitors and are added to the next 'generation' depending on the resources they recieved. 

With the help of an R-script the abundance of each competitor can be observed in an updated pdf-file

Some example trategies:
- dove : never fights
- hawk : always fights
- rand : makes a random decision

