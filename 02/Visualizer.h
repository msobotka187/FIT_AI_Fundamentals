#ifndef VISUALIZER_H
#define VISUALIZER_H

#include "TSPGraph.h"
#include "SimulatedAnnealing.h"

class Visualizer {
public:
  // Constructors and destructor
  Visualizer(
      const TSPGraph & graph,
      SimulatedAnnealing & sa,
      int width,
      int height
  );
  ~Visualizer() = default;

  // Main window loop
  bool run();

private:
  const TSPGraph & m_graph;
  SimulatedAnnealing & m_sa;
  int m_width;
  int m_height;

  // Drawing itself
  void draw(bool isBtnHovered);
};

#endif // VISUALIZER_H
