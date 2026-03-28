#include "TSPGraph.h"
#include "SimulatedAnnealing.h"
#include "Visualizer.h"

#include <iostream>
#include <thread>
#include <chrono>

int main() {
  // 1. Set params
  int numCities = 50;
  int screenWidth  = 1200;
  int screenHeight = 800;

  double startTemp = 1000.0;
  double minTemp = 1.0;
  double coolingRate = 0.99;
  int iterationsPerStep = 100;

  std::cout << "Generating graph with " << numCities << " cities\n";
  TSPGraph graph(numCities, screenWidth, screenHeight);

  std::cout << "Initializing simulated annealing...\n\n";
  SimulatedAnnealing sa(graph, startTemp, minTemp, coolingRate, iterationsPerStep);

  std::cout << "Launching visualization...\n\n";
  Visualizer viz(graph, sa, screenWidth, screenHeight);
  viz.run();

  return 0;
}
