namespace NonlocalGames {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    //Accepts two referee bits, each 0 or 1, returns two measurement results in an int array
    operation PlayCHSHGame(x: Int, y: Int) : Int[] {
        use alice = Qubit();
        use bob = Qubit();

        //set up CHSH state:
        H(alice);
        CNOT(alice,bob);

        //employ strategy
        if (x == 1) {
            Ry(PI()/2.,alice);
        }
        let a = M(alice);

        if (y == 0) {
            Ry(PI()/4., bob);
        }
        else {
            Ry(-1.*PI()/4., bob);
        }
        let b = M(bob);

        return [(a == One ? 1 | 0),b == One ? 1 | 0];
    }

    //Accepts three referee bits, each 0 or 1, returns three measurement results in an int array
    operation PlayGHZGame(x: Int, y: Int, z: Int) : Int[] {
        use alice = Qubit();
        use bob = Qubit();
        use charlie = Qubit();

        //set up GHZ state
        H(alice);
        CNOT(alice, bob);
        CNOT(bob, charlie);
        
        //employ strategy
        if (x == 1) {
            Rz(PI()/2.,alice);
        }
        H(alice);

        if (y == 1) {
            Rz(PI()/2.,bob);
        }
        H(bob);

        if (z == 1) {
            Rz(PI()/2.,charlie);
        }
        H(charlie);

        return [M(alice) == One ? 1 | 0,M(bob) == One ? 1 | 0,M(charlie) == One ? 1 | 0];
    }
}
