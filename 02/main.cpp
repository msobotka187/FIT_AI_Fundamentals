#include "TSPGraph.h"
#include "SimulatedAnnealing.h"
#include "Visualizer.h"
#include "Constants.h"

#include <raylib.h>
#include <iostream>

int main() {
  InitWindow(Constants::SCREEN_WIDTH, Constants::SCREEN_HEIGHT, "TSP - SimulatedAnnealing");
  SetTargetFPS(60);

  bool playAgain = true;

  // 1. Main restart loop
  while (playAgain) {
    TSPGraph graph(Constants::NUM_CITIES);
    SimulatedAnnealing sa(graph);
    Visualizer viz(graph, sa);

    playAgain = viz.run();
  }

  // 2. Safely close the window
  CloseWindow();

  return 0;
}
