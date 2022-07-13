namespace NonlocalGames {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math; //needed for PI()
    open Microsoft.Quantum.Preparation; //needed for preparing the GHZ state
    open Microsoft.Quantum.Arithmetic; //needed for LittleEndian

    //Accepts two referee bits, each 0 or 1, returns two measurement results in an int array
    operation PlayCHSHGame(x: Int, y: Int) : Int[] {
        use alice = Qubit();
        use bob = Qubit();

        //set up CHSH (Bell) state:
        H(alice);
        CNOT(alice,bob);

        //employ strategy
        //if alice receives 1, rotate into new basis of theta = pi/4
        if (x == 1) {
            Ry(PI()/2.,alice);
        }

        //if bob receives 0, rotate into new basis of theta = pi/8, or -pi/8 if he received 1
        if (y == 0) {
            Ry(PI()/4., bob);
        }

        else {
            Ry(-1.*PI()/4., bob);
        }

        //return measurement result as int
        return [M(alice) == One ? 1 | 0,M(bob) == One ? 1 | 0];
    }

    //Accepts three referee bits, each 0 or 1, returns three measurement results in an int array
    operation PlayGHZGame(x: Int, y: Int, z: Int) : Int[] {
        //players each start with a qubit in |0>
        use alice = Qubit();
        use bob = Qubit();
        use charlie = Qubit();

        //set up initial GHZ state
        //start with 1/2(|0>-|3>-|5>-|6>) (little endian for this function)
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

        //Another way to set this up without PrepareArbitraryStateCP:
        //start in |000>
        //Reset(alice);
        //Reset(bob);
        //Reset(charlie);

        //Apply X to alices qubit to flip the first bit to get |100> = |1>
        //X(alice);

        //Apply X to bobs qubit to flip secont bit to get |110> = |3>
        //X(bob);

        //Apply H to alices qubit to get 1/sqrt(2)(|010>-|110>) = 1/sqrt(2)(|2>-|3>)
        //notice how H splits the single |3> state into two components. We need to do it once more
        //H(alice);

        //Apply H to bobs qubit to get 1/2(|000>-|010>-|100>-|111>)
        //H(bob);

        //Apply CZ to alices control bit and bobs target bit to get 1/2(|000>-|010>-|100>-|110>)
        //CZ(alice,bob);

        //Apply controlled not to charlies qubit with second qubit as control to get 1/2(|000>-|100>-|011>-|111>)
        //CNOT(bob,charlie);

        //Apply controlled not to charlies qubit with first qubit as control to get 1/2(|000>-|110>-|101>-|011>), the desired state
        //CNOT(alice,charlie);
        

        //employ strategy
        for bit in 0 .. 2{
            //each player receives a question bit, performs a Hadamard on their qubit if bit was 1
            if ([x,y,z][bit]==1) {
                H([alice,bob,charlie][bit]);
            }
        }

        //return measurement result as int
        return [M(alice) == One ? 1 | 0,M(bob) == One ? 1 | 0,M(charlie) == One ? 1 | 0];
    }
}
