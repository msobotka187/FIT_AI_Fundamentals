#ifndef VISUALIZER_H
#define VISUALIZER_H

#include "TSPGraph.h"
#include "SimulatedAnnealing.h"

class Visualizer {
public:
  // Constructors and destructor
  Visualizer(
      const TSPGraph & graph,
      SimulatedAnnealing & sa
  );
  ~Visualizer() = default;

  // Main window loop
  bool run();

private:
  const TSPGraph & m_graph;
  SimulatedAnnealing & m_sa;

  // Drawing itself
  void draw(bool isBtnHovered);
};

#endif // VISUALIZER_H
