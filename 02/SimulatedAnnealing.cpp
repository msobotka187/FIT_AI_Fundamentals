#include "SimulatedAnnealing.h"
#include <numeric>
#include <algorithm>
#include <cmath>

SimulatedAnnealing::SimulatedAnnealing(
    const TSPGraph & graph,
    double startTemp,
    double minTemp,
    double coolingRate,
    int iterationsPerStep
)
  : m_graph(graph),
    m_currTemp(startTemp),
    m_minTemp(minTemp),
    m_coolingRate(coolingRate),
    m_iterationsPerStep(iterationsPerStep)
{
  std::random_device rd;
  m_gen.seed(rd());

  generateInitialRoute();
  m_currDistance = calculateDistance(m_currRoute);

  m_bestRoute    = m_currRoute;
  m_bestDistance = m_currDistance;
}

void SimulatedAnnealing::generateInitialRoute() {
  int n = m_graph.getNumCities();
  m_currRoute.resize(n);

  // Fill m_currRoute with 0, 1, 2, ..., n-1
  std::iota(m_currRoute.begin(), m_currRoute.end(), 0);

  // Randomly shuffle initial Route
  std::shuffle(m_currRoute.begin(), m_currRoute.end(), m_gen);
}

double SimulatedAnnealing::calculateDistance(const std::vector<int> & route) const {
  double dist = 0.0;
  int n = route.size();

  // Add distances between two following cities
  for (int i = 0; i < n; i++) {
    dist += m_graph[route[i]][route[i + 1]];
  }
  // Add distance between the last and first as well
  dist += m_graph[route[n - 1]][route[0]];

  return dist;
}

// TODO: what if getNumCities is 1? handle this somehow
void SimulatedAnnealing::step() {
  if (isDone()) return;

  std::uniform_real_distribution<> probDist(0.0, 1.0);
  std::uniform_int_distribution<>  cityDist(0, m_graph.getNumCities() - 1);

  for (int i = 0; i < m_iterationsPerStep; i++) {
    // Choose two random indices for 2-opt exchange
    int idx1 = cityDist(m_gen);
    int idx2 = cityDist(m_gen);

    while (idx1 == idx2) {
      idx2 = cityDist(m_gen);
    }

    // Make idx1 smaller
    if (idx1 > idx2) std::swap(idx1, idx2);

    // Create neighboring state (2-opt: reverse route between idx1 and idx2)
    std::vector<int> newRoute = m_currRoute;
    std::reverse(newRoute.begin() + idx1, newRoute.begin() + idx2 + 1);

    double newDistance = calculateDistance(newRoute);

    // Metropolis criterion
    double deltaE = m_currDistance - newDistance;
    if (
        newDistance < m_currDistance ||   // We take newRoute if newDistnace is smaller
        probDist(m_gen) < std::exp(deltaE / m_currTemp) // or with probability < e^(ΔE / cT) even if it's worse (avoid local mins)
    ) {
      m_currRoute    = std::move(newRoute);
      m_currDistance = newDistance;

      // Global minimum update
      if (m_currDistance < m_bestDistance) {
        m_bestRoute    = m_currRoute;
        m_bestDistance = m_currDistance;
      }
    }
  }

  // Cooling
  m_currTemp *= m_coolingRate;
}

bool SimulatedAnnealing::isDone() const {
  return m_currTemp <= m_minTemp;
}

// Getters
const std::vector<int> & SimulatedAnnealing::getBestRoute() const { return m_bestRoute; }
const std::vector<int> & SimulatedAnnealing::getCurrRoute() const { return m_currRoute; }
double SimulatedAnnealing::getBestDistance() const { return m_bestDistance; }
double SimulatedAnnealing::getCurrTemp()     const { return m_currTemp; }
