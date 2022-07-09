# Nonlocal Games

## Motivation
### A question posed
Under *locality*, actions performed on one system do not affect the state of another faster than light. Appealing to this idea, Einsten, Podolsky, and Rosen published a [paper](https://journals.aps.org/pr/abstract/10.1103/PhysRev.47.777) in 1935 suggesting that quantum mechanics had a paradox hiding in its predictions for measurement outcomes of entangled sets of quantum objects.

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

Think for a moment, is there *any* $a$ and $b$ the players can always answer to win? A good one would be to have both players always respond with $1$, because $a\oplus b$ is always $0$ and thus they win $75$% of the time. In fact, this is an optimal strategy if Alice and Bob cannot violate locality, according to Bell's theorem. If we can devise a quantum strategy that wins more often, we have shown experimentally that local theories fail.

I will skip mostly why the strategy works and how it was constructed. The winning condition was designed to be strategized for use with entanglement.

Instead of using bits, Alice and Bob will now use qubits, and will be answering the referee's questions with measurement results. 


The strategy begins by creating the following entangled state:

$$\ket{\psi}=\frac{1}{\sqrt{2}}(\ket{00}+\ket{11})$$

This is the classic Bell state. To construct it, first apply a Hadamard gate to $\ket{0}$ to place it in superposition, and add a second $\ket{0}$ qubit to the register:

$$H(\ket{0})=\frac{1}{\sqrt{2}}(\ket{0}+\ket{1})\quad\Rightarrow\quad\frac{1}{\sqrt{2}}(\ket{00}+\ket{10})$$

Now, we just need to flip the second qubit in the second ket without flipping it in the first one. Recall that a controlled not gate does exactly that if the first qubit in the ket is a $1$.

$$CNOT\left(\frac{1}{\sqrt{2}}(\ket{00}+\ket{10})\right) = \frac{1}{\sqrt{2}}(\ket{00}+\ket{11})$$

The next step of the strategy is to define a new basis as a function of some angle 

$$\phi_0(\theta)=\cos\theta\ket{0}+\sin\theta\ket{1}$$

$$\phi_1(\theta)=-\sin\theta\ket{0}+\cos\theta\ket{1}$$

This may look similar to an operation you've seen before. Remember that the $R_y$ gate is:

$$R_y(\theta) = \begin{bmatrix}
 \cos\frac{\theta}{2} & \sin\frac{\theta}{2} \\
 -\sin\frac{\theta}{2} & \cos\frac{\theta}{2} \\
 \end{bmatrix}$$

Transorming to any basis 
$$\{\phi_0(\theta),\phi_1(\theta)\}$$

 is simply a matter of applying the $R_y$ gate with twice the angle to the old basis. Rotating a qubit $\ket{\psi_i}$ in state $a\ket{0}+b\ket{1}$ into this new basis is now:

$$R_y(2\theta)\ket{\psi_i} = \begin{bmatrix}
 \cos\theta & \sin\theta \\
 -\sin\theta & \cos\theta \\
 \end{bmatrix} \begin{bmatrix} a\\ b\end{bmatrix}$$

as we wanted.

Now the game is played. If Alice receives $\ x=1 \ $, she  will measure her qubit in the basis corresponding to $\theta=\frac{\pi}{4}$, and in the standard basis otherwise. 

If Bob receives $ \ y=0 \ $, he will measure his qubit in the basis corresponding to $\theta=\frac{\pi}{8}$, and in the basis corresponding to $\theta=-\frac{\pi}{8}$ otherwise.



 

