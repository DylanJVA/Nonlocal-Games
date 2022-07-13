using Microsoft.Quantum.Simulation.Simulators;
using System;
using System.Threading.Tasks;

namespace NonlocalGames {
    class Driver {
        static void  Main(string[] Args) {
            Console.WriteLine("Enter CHSH to play CHSH games or GHZ to play GHZ games, anything else to quit.");
            string choice = Console.ReadLine();

            Console.WriteLine("How many games do you want to play?");
            int numGames = Convert.ToInt32(Console.ReadLine());
            Random rng = new Random();
            
            int wins = 0;
            for (int game = 0; game < numGames; game++) {
                
                using (var sim = new QuantumSimulator()) {
                    if (choice == "CHSH") {
                        //random question bit to each player
                        int x = rng.Next(0,2);
                        int y = rng.Next(0,2);      
                        
                        //simulate CHSH strategy              
                        var results = PlayCHSHGame.Run(sim,x,y).Result;
                        
                        //check if CHSH winning condition is met, if so count the win
                        if (CHSHWinCondition(x,y,Convert.ToInt32(results[0]),Convert.ToInt32(results[1]))) {
                            wins++;
                        }
                    }
                    else if (choice == "GHZ"){
                        //random questionlist from the set:
                        int[,] questionsList= new int[,] {{0,0,0},{0,1,1},{1,0,1},{1,1,0}};
                        int rand = rng.Next(0,4);
                        int x = questionsList[rand,0];
                        int y = questionsList[rand,1];
                        int z = questionsList[rand,2];
                        
                        //simulate GHZ strategy
                        var results = PlayGHZGame.Run(sim,x,y,z).Result;

                        //check if GHZ winning condition is met, if so count the win
                        if (GHZWinCondition(x,y,z,Convert.ToInt32(results[0]),Convert.ToInt32(results[1]),Convert.ToInt32(results[2]))) {
                            wins++;
                        }
                    }
                }
                
            }
            //Prints the overall win percentage to be compared with 75% - the nonlocal limit
            Console.WriteLine("Win %: " + (double)wins/(double)numGames);
        }

        static bool CHSHWinCondition(int r, int s, int a, int b) {
            return (r & s) == (a ^ b);
        }

        static bool GHZWinCondition(int r, int s, int t, int a, int b, int c) {
            return (r | s | t) == (a ^ b ^ c);
        }
    }
}