using Microsoft.Quantum.Simulation.Simulators;
using System;
using System.Threading.Tasks;

namespace NonlocalGames {
    class Driver {
        static void  Main(string[] Args) {
            Console.WriteLine("Enter CHSH to play CHSH games or GHZ to play GHZ games");
            string choice = Console.ReadLine();

            Console.WriteLine("How many games do you want to play?");
            int numGames = Convert.ToInt32(Console.ReadLine());
            Random rng = new Random();
            
            int wins = 0;
            for (int game = 0; game < numGames; game++) {
                
                using (var sim = new QuantumSimulator()) {
                    if (choice == "CHSH") {
                        int x = rng.Next(0,2);
                        int y = rng.Next(0,2);                    
                        var results = PlayCHSHGame.Run(sim,x,y).Result;
                        if (CHSHWinCondition(x,y,Convert.ToInt32(results[0]),Convert.ToInt32(results[1]))) {
                            wins++;
                        }
                    }
                    else {
                        int[,] questionsList= new int[,] {{0,0,0},{0,1,1},{1,0,1},{1,1,0}};
                        int rand = rng.Next(0,4);
                        int x = questionsList[rand,0];
                        int y = questionsList[rand,1];
                        int z = questionsList[rand,2];
                        var results = PlayGHZGame.Run(sim,x,y,z).Result;
                        if (GHZWinCondition(x,y,z,Convert.ToInt32(results[0]),Convert.ToInt32(results[1]),Convert.ToInt32(results[2]))) {
                            wins++;
                        }
                    }
                }
                
            }
            Console.WriteLine("Win %: " + (double)wins/(double)numGames);
        }

        static bool CHSHWinCondition(int x, int y, int a, int b) {
            return (Convert.ToBoolean(x) & Convert.ToBoolean(y)) == (Convert.ToBoolean(a) != Convert.ToBoolean(b));
        }

        static bool GHZWinCondition(int x, int y, int z, int a, int b, int c) {
            return (x | y | z) == (a ^ b ^ c);
        }
    }
}