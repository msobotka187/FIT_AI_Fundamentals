#include "TSPGraph.h"
#include "SimulatedAnnealing.h"

#include <iostream>
#include <iomanip>

int main() {
  // 1. Set params
  int numCities = 50;
  double mapWidth = 100.0;
  double mapHeight = 100.0;

  double startTemp = 1000.0;
  double minTemp = 0.1;
  double coolingRate = 0.99;
  int iterationsPerStep = 100;

  std::cout << "Generating graph with " << numCities << " cities\n";
  TSPGraph graph(numCities, mapWidth, mapHeight);

  std::cout << "Initializing simulated annealing...\n\n";
  SimulatedAnnealing sa(graph, startTemp, minTemp, coolingRate, iterationsPerStep);

  std::cout << "Initial distance: " << sa.getBestDistance() << std::endl;
  std::cout << "Starting the calculation...\n\n";

  int stepCount = 0;
  while (!sa.isDone()) {
    sa.step();
    stepCount++;

    // Print out the state every 100 steps
    if (stepCount % 100 == 0) {
      std::cout << "Step: " << stepCount
                << " | Temperature: " << std::fixed << std::setprecision(2) << sa.getCurrTemp()
                << " | Best Distance: " << sa.getBestDistance() << std::endl;
    }
  }

  // 3. result
  std::cout << "\n\n--- DONE ---\n";
  std::cout << "Final best distance: " << sa.getBestDistance() << std::endl;
  std::cout << "Fianl number of steps: " << stepCount << std::endl;
  std::cout << "Number of iterations: " << stepCount * iterationsPerStep << std::endl;
}
