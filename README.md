# Nonlocal Games

## Motivation
### A question posed
Under *locality*, actions performed on one system do not affect the state of another faster than light could mediate that effect. Appealing to this idea, Einsten, Podolsky, and Rosen published a [paper](https://journals.aps.org/pr/abstract/10.1103/PhysRev.47.777) in 1935 suggesting that quantum mechanics had a paradox hiding in its predictions for measurement outcomes of entangled sets of quantum objects.

### A testable theory
John Bell, a physicist on leave from CERN in 1964 [answered](https://journals.aps.org/ppf/abstract/10.1103/PhysicsPhysiqueFizika.1.195) the question with rigor: Local theories about quantum mechanics will have a bound on correlations between measurements. Nonlocal theories will be able to violate this bound.
4 more physicists; Clauser, Horne, Shimony, Holt (CHSH) devised an [experiment](https://www.semanticscholar.org/paper/Proposed-Experiment-to-Test-Local-Hidden-Variable-Clauser-Horne/8864c5214a30a7acd8d186f53e8991cd8bc88f84) that will test these bounds with two quantum systems. Another group, Greenberger, Horne, and Zeilinger (GHZ) [proved](https://arxiv.org/abs/0712.0921) that there local theories disagree with nonlocal theories on what is possible and impossible, not just the probabilistic predictions. We will explore these experiments in the form of games, and implement them using quantum computing. 

We will be working from John Watrous' [lecture notes](https://cs.uwaterloo.ca/~watrous/QC-notes/QC-notes.20.pdf) on the two games.

## Implementation
### The CHSH Game

The CHSH inequality can be formulated as a game. It is played with two players, we'll call them Alice and Bob as usual, and a referee.
1. The referee poses a random question bit, $x\in{0,1}$ to Alice and $y\in{0,1}$ to Bob.
2. The players must each respond with their own bit, $a$ for Alice and $b$ for Bob, without classical communication with the other.
3. The players win if $x\wedge y = a \oplus b$.

Before trying to employee quantum computing, lets just try to think of a regular strategy that would work to win. We can construct a truth table to observe which conditions Alice and Bob can employ to win. On the left are the values of $x$ and $y$ and on the right is what $a\oplus b$ needs to be to win.

| $x$ | $y$ | $a \oplus b$ |
|:---:|:---:|:------------:|
|  0  |  0  |      0       |
|  0  |  1  |      0       |
|  1  |  0  |      0       |
|  1  |  1  |      1       |