# Nonlocal Games

## Background
Why did Einstein call entanglement *spooky action at a distance*? He, Podolsky, and Rosen published a [paper](https://journals.aps.org/pr/abstract/10.1103/PhysRev.47.777) in 1935 suggesting that quantum mechanics had a paradox hiding in its predictions for measurement outcomes of entangled sets of quantum objects. They said that given an experiment in which the outcome is known before the measurement takes place, there is an 'element of reality' associated with the experiment that determines the measurement outcome. And these elements of reality should be *local*, belonging to a coordinate in spacetime which cannot be changed by something a distance away faster than light. They argued that a choice of measurement done on particle $A$ should not lead to two different quantum states for particle $B$ far away.

John Bell, a physicist on leave from CERN in 1964 [answered](https://journals.aps.org/ppf/abstract/10.1103/PhysicsPhysiqueFizika.1.195) the question with a rigorous test: local theories about quantum mechanics will have a bound on correlations between measurements of the z-component of spin for entangled pairs of spin-half particles (fermions).  Nonlocal theories will be able to violate this bound. A choice of measurement done on particle $A$ can lead to two different quantum states for particle $B$ far away.

Spin is an intrinsic property of a particle like mass or charge, and when combined with the classical angular momentum it describes the state of the particle consistent with conservation of angular momentum. The overall spin of any particle, $s$, and the z-component of the spin, $s_z$ may take different values, but for a spin-half particle $s$ is always $\frac{1}{2}$, and $s_z$ can only be either up, $\frac{1}{2}$, or down, $-\frac{1}{2}$ ($s_z$ can only take half-integer values up to $\pm s$). Now the state of the particle at rest is described by $\ket{s,s_z}$ and can only be $\ket{\frac{1}{2},\frac{1}{2}}$ or $\ket{\frac{1}{2},-\frac{1}{2}}$. Because $s$ doesnt matter and there are only two possible spin states, this is a qubit, and we can use the convention that $\ket{\frac{1}{2},\frac{1}{2}} = \ket{0}$ (spin up) and $\ket{\frac{1}{2},-\frac{1}{2}} = \ket{1}$ (spin down). 

Four more physicists; Clauser, Horne, Shimony, Holt (CHSH) devised an [experiment](https://www.semanticscholar.org/paper/Proposed-Experiment-to-Test-Local-Hidden-Variable-Clauser-Horne/8864c5214a30a7acd8d186f53e8991cd8bc88f84) that will test these bounds with two particles. Another group, Greenberger, Horne, and Zeilinger (GHZ) [proved](https://arxiv.org/abs/0712.0921) that local theories disagree with nonlocal theories on what is possible and impossible, not just differences in probabilistic predictions for measurements.

We will explore these experiments in the form of games, and implement them using quantum computing and working from John Watrous' [lecture notes](https://cs.uwaterloo.ca/~watrous/QC-notes/QC-notes.20.pdf) on the two games.

## Implementation
### The CHSH Game

The CHSH inequality, a test of Bell's theorem, can be formulated as a game. It is played with two players, we'll call them Alice and Bob as usual, and a referee.

1. The referee poses a random question bit, $x\in\{0,1\}$ to Alice and $y\in\{0,1\}$ to Bob.
2. The players must each respond with their own bit, $a$ for Alice and $b$ for Bob, without classical communication with the other.
3. The players win if $x\wedge y = a \oplus b$. [(What do $\wedge$ (AND) and $\oplus$ (XOR) mean again?)](../classical-computing/digital-logic.md#binary-gates)

Before trying to employ quantum computing, lets just try to think of a regular strategy for this game. We can construct a truth table to observe which conditions Alice and Bob need to work towards to win. On the left is the possible question combination and on the right is what $a\oplus b$ needs to be for Alice and Bob to win. 

| $x$ | $y$ | $a \oplus b$ |
|:---:|:---:|:------------:|
|  0  |  0  |      0       |
|  0  |  1  |      0       |
|  1  |  0  |      0       |
|  1  |  1  |      1       |

Think for a moment, is there *any* $a$ and $b$ the players can always answer to win? A good one would be to have both players always respond with $1$, because $a\oplus b$ is always $0$ and thus they win $75$% of the time. In fact, this is an optimal strategy if Alice and Bob cannot violate locality, according to the bound set by Bell's theorem. If we can devise a quantum strategy that wins more often, we have shown experimentally that local theories fail.

I will skip mostly why the strategy works and how it was constructed. The winning condition was designed to be strategized for use with entanglement.

Instead of using bits, Alice and Bob will now use qubits, and will be answering the referee's questions with measurement results. 


The strategy begins by creating the following entangled state:

$$\ket{\psi}=\frac{1}{\sqrt{2}}(\ket{00}+\ket{11})$$

This is the classic Bell state. To construct it, first apply a Hadamard gate to $\ket{0}$ to place it in superposition, and add a second $\ket{0}$ qubit to construct the two-qubit register:

$$H\ket{0}=\frac{1}{\sqrt{2}}(\ket{0}+\ket{1})\quad\underset{\otimes\ \ket{0}}{\Rightarrow}\quad\frac{1}{\sqrt{2}}(\ket{00}+\ket{10})$$

Now, we just need to flip the second qubit in the second ket without flipping it in the first one. Recall that a controlled not gate does exactly that if the first qubit in the ket is a $1$.

$$CNOT\left(\frac{1}{\sqrt{2}}(\ket{00}+\ket{10})\right) = \frac{1}{\sqrt{2}}(\ket{00}+\ket{11})$$

The next step of the strategy is to define a new basis as a function of the angle $\theta$

$$\phi_0(\theta)=\cos\theta\ket{0}+\sin\theta\ket{1}$$

$$\phi_1(\theta)=-\sin\theta\ket{0}+\cos\theta\ket{1}$$

This may look similar to an operation you've seen before. Remember that the $R_y$ gate is:

$$R_y(\theta) = \begin{bmatrix}
 \cos\frac{\theta}{2} & \sin\frac{\theta}{2} \\
 -\sin\frac{\theta}{2} & \cos\frac{\theta}{2} \\
 \end{bmatrix}$$

Transorming to any basis $\{\phi_0(\theta),\phi_1(\theta)\}$ is simply a matter of applying the $R_y$ gate with twice the angle to the old basis. Rotating a qubit $\ket{\psi_i}$ in state $a\ket{0}+b\ket{1}$ into this new basis is now:

$$R_y(2\theta)\ket{\psi_i} = \begin{bmatrix}
 \cos\theta & \sin\theta \\
 -\sin\theta & \cos\theta \\
 \end{bmatrix} \begin{bmatrix} a\\ b\end{bmatrix}$$

as we wanted.

Now the game is played. If Alice receives $x=1$, she  will measure her qubit in the basis corresponding to $\theta=\frac{\pi}{4}$, and in the standard basis otherwise. 

If Bob receives $y=0$, he will measure his qubit in the basis corresponding to $\theta=\frac{\pi}{8}$, and in the basis corresponding to $\theta=-\frac{\pi}{8}$ otherwise.

As it turns out, this strategy will win $85$% of the time, which clearly beats out the classical bound set by Bell's theorem. It is also the optimal strategy according to the new bound with nonlocal theories, [Tsirelson's Bound](https://en.wikipedia.org/wiki/Tsirelson%27s_bound).

### The GHZ Game

The GHZ game is similar to the CHSH game except there is one more player. This time, the question bits $rst$ posed by the referee are not completely random;

1. The referee chooses them uniformly from the set $xyz\in\{000,011,101,110\}$. 
2. The winning condition for this game is if $x\vee y\vee z = a \oplus b \oplus c$.

We can construct another table to show us which value $a\oplus b\oplus c$ needs to take to win.

| $xyz$ | $a \oplus b$ |
|:-----:|:------------:|
|  000  |      0       |
|  011  |      1       |
|  101  |      1       |
|  110  |      1       |

Again the best possible classical strategy will win $75$% of the time (can you come up with it?). We will turn to entangled qubits to see if we can do better.

First Alice, Bob, and Charlie will need to construct the initial state in a register with their qubits. The state will be 

$$\ket{\psi}=\frac{1}{2}(\ket{000}-\ket{011}-\ket{101}-\ket{110})$$

This is the state we will be using, however the famous 3-qubit GHZ state is given by

$$\frac{1}{\sqrt{2}}(\ket{000}+\ket{111})$$

and is equivalent under some operations. It is not elementary to construct the desired $\ket{\psi}$ from the standard gates, however it can be done. It can also be done by simply preparing the qubit register exactly as given with the amplitudes. We can write the state of the register in terms of the $8$ basis vectors converted from little-endian binary to decimal, where the digit in the ket is now the index of the qubit in the qubit register:

$$\ket{\psi}=\frac{1}{2}(\ket{0}-\ket{3}-\ket{5}-\ket{6})$$

We can construct this register easily in Q# using qubits named `alice, bob, charlie` now with an array of complex amplitudes `state` for the amplitudes and the `PrepareArbitraryStateCP` function. Note that I chose little-endian because this function specifically requires it.

```
let state = [
    ComplexPolar(0.5,0.), //|0>
    ComplexPolar(0.,0.),  //|1>
    ComplexPolar(0.,0.),  //|2>
    ComplexPolar(-0.5,0.),//|3>
    ComplexPolar(0.,0.),  //|4>
    ComplexPolar(-0.5,0.),//|5>
    ComplexPolar(-0.5,0.),//|6>
    ComplexPolar(0.,0.)   //|7>
];
PrepareArbitraryStateCP(state,LittleEndian([alice,bob,charlie]));
```

To play this game, the players will apply a hadamard gate to their qubit only if they receive a $1$ from the referee and return the measurement outcome in the standard basis. 

This game was designed to show that while it is impossible for a true winning classical strategy, it is possible to win every time with the quantum one. It is a proof of possibilistic disagreements with nonlocal and local theories, which are stronger than probabilistic disagreements as in the CHSH game. 

You can see why it wins each time by looking at the cases:

- Case 1: $xyz=000$. None of the question bits are $1$, so all players will measure their qubits in the initial state. Looking at all the possible measurement outcomes to check the evaluation of $a\oplus b\oplus c$: 
  
    - $0\oplus 0\oplus 0=0$
    - $0\oplus 1\oplus 1=0$
    - $1\oplus 0\oplus 1=0$
    - $1\oplus 1\oplus 0=0$

    Because in every outcome the result is $0$, and because for $xyz=000$, $x\vee y\vee z=0$, they win in this case every time.

- Case 2: $xyz\in\{011,101,110\}$. Since there are the same number of $1$s and $0$s in each option, they work the same by symmetry. Whoever receives a $1$ applies a Hadamard gate, but there will always be two players applying the gate. The state of the qubit register after the Hadamard operations is:
  
    $$ (I\otimes H\otimes H)\ket{\psi}=\frac{1}{2}(\ket{001}+\ket{010}-\ket{100}+\ket{111}) $$

    Remember, we applied the Hadamard gates to only one qubit each, so we needed to include the $I\ \otimes$.
    Lets look again at the possible values of $a\oplus b\oplus c$:

    - $0\oplus 0\oplus 1=1$
    - $0\oplus 1\oplus 0=1$
    - $1\oplus 0\oplus 0=1$
    - $1\oplus 1\oplus 1=1$

    It is obvious for this case that $x\vee y\vee z = 1$ in every scenario, so the players will win in this case every time as well. 
