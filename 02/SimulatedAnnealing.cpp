#include "SimulatedAnnealing.h"
#include "Constants.h"

#include <numeric>
#include <algorithm>
#include <cmath>

SimulatedAnnealing::SimulatedAnnealing(const TSPGraph & graph)
  : m_graph(graph),
    m_currTemp(Constants::START_TEMP),
    m_minTemp(Constants::MIN_TEMP),
    m_coolingRate(Constants::COOLING_RATE),
    m_iterationsPerStep(Constants::ITERATIONS_PER_STEP)
{
  std::random_device rd;
  m_gen.seed(rd());

  // Does not make sence for less than 3 cities
  if (m_graph.getNumCities() < 3) {
    m_currDistance = 0.0;
    m_bestDistance = 0.0;
    return;
  }

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
  for (int i = 0; i < n - 1; i++) {
    dist += m_graph[route[i]][route[i + 1]];
  }
  // Add distance between the last and first as well
  dist += m_graph[route[n - 1]][route[0]];

  return dist;
}

double SimulatedAnnealing::calculateDistanceDiff(int idx1, int idx2) const {
  int n = m_currRoute.size();

  // ... -> A -> [B -> ... -> C] -> D -> ...
  // Edge A -> B and C -> D gets deleted
  // Everything iniside B -> ... -> C stays unchaned (only reversed)

  // Cities on the edge
  int cityB = m_currRoute[idx1];
  int cityC = m_currRoute[idx2];

  // Cities before and after reversed range
  int cityA = m_currRoute[(idx1 - 1 + n) % n];
  int cityD = m_currRoute[(idx2 + 1) % n];

  // Old edges gets deleted
  double oldEdges = m_graph[cityA][cityB] + m_graph[cityC][cityD];

  // New edges are added
  double newEdges = m_graph[cityA][cityC] + m_graph[cityB][cityD];

  // And return difference between them
  return newEdges - oldEdges;
}

void SimulatedAnnealing::step() {
  // Does not make sense to solve for less then 3 cities,
  // it could also, for 1 city, enter a infinite loop in while (idx1 == idx2)
  if (isDone() || m_graph.getNumCities() < 3) return;

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

    // If we would reverse the whole thing, nothing would change
    if (idx1 == 0 && idx2 == m_graph.getNumCities() - 1) continue;

    double diff = calculateDistanceDiff(idx1, idx2);

    // Metropolis criterion
    if (
        diff < 0 ||   // We take newRoute if newDistnace (diff) is smaller (< 0)
        probDist(m_gen) < std::exp(-diff / m_currTemp) // or with probability < e^(ΔE / cT) even if it's worse (avoid local mins)
    ) {
      // Reverse it here
      std::reverse(m_currRoute.begin() + idx1, m_currRoute.begin() + idx2 + 1);
      m_currDistance += diff;

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
double SimulatedAnnealing::getMinTemp()      const { return m_minTemp;  }
