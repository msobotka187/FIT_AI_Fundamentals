#ifndef SIMULATEDANNEALING_H
#define SIMULATEDANNEALING_H

#include "TSPGraph.h"
#include <vector>
#include <random>

class SimulatedAnnealing {
public:
  // Constructors
  SimulatedAnnealing(
      const TSPGraph & graph,
      double startTemp,
      double minTemp,
      double coolingRate,
      int iterationsPerStep
  );

  // Getters
  const std::vector<int> & getBestRoute() const;
  const std::vector<int> & getCurrRoute() const;
  double getBestDistance() const;
  double getCurrTemp() const;

  // Does one step of the algorithm
  void step();

  // Check if we're cooled
  bool isDone() const;

private:
  const TSPGraph & m_graph; // Reference to data to avoid copying

  // Annealing params
  double m_currTemp;
  double m_minTemp;
  double m_coolingRate;
  int    m_iterationsPerStep;

  // State variables
  std::vector<int> m_currRoute;
  std::vector<int> m_bestRoute;
  double m_currDistance;
  double m_bestDistance;

  std::mt19937 m_gen;

  // Helper private methods
  void generateInitialRoute();
  double calculateDistance(const std::vector<int> & route) const;
};

#endif // SIMULATEDANNEALING_H
