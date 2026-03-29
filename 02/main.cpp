#include "TSPGraph.h"
#include "SimulatedAnnealing.h"
#include "Visualizer.h"

#include <raylib.h>
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

  InitWindow(screenWidth, screenHeight, "TSP - SimulatedAnnealing");
  SetTargetFPS(60);

  bool playAgain = true;

  // 2. Main restart loop
  while (playAgain) {
    TSPGraph graph(numCities, screenWidth, screenHeight);
    SimulatedAnnealing sa(graph, startTemp, minTemp, coolingRate, iterationsPerStep);
    Visualizer viz(graph, sa, screenWidth, screenHeight);

    playAgain = viz.run();
  }

  // 3. Safely close the window
  CloseWindow();

  return 0;
}
