#include "TSPGraph.h"
#include <random>

TSPGraph::TSPGraph(int numCities, double width, double height) : m_numCities(numCities) {
  // C++ random generator
  std::random_device rd;
  std::mt19937 gen(rd());

  // "Real" numbers form 0 - width/height
  double marginUP    = 80.0;
  double marginDOWN  = 30.0;
  double marginLEFT  = 30.0;
  double marginRIGHT = 30.0;
  std::uniform_real_distribution<> disX(marginLEFT, width  - marginRIGHT);
  std::uniform_real_distribution<> disY(marginUP,   height - marginDOWN);

  // Pass them to vector
  m_cities.reserve(numCities);
  for (int i = 0; i < numCities; i++) {
    m_cities.emplace_back(i, disX(gen), disY(gen));
  }

  // And calculate distances
  precomputeDistanceMatrix();
}

void TSPGraph::precomputeDistanceMatrix() {
  int n = m_cities.size();
  // Create empty matrix with zeros
  m_distanceMatrix.assign(n * n, 0.0);

  // Iterate through upper triangular matrix
  for (int i = 0; i < n; i++) {
    for (int j = i + 1; j < n; j++) {
      double dist = m_cities[i].distanceTo(m_cities[j]);

      // Symmetrical write into matrix
      (*this)[i][j] = dist;
      (*this)[j][i] = dist;
    }
  }
}

// O(1) lookup
double TSPGraph::getDistance(int from, int to) const {
  return (*this)[from][to];
}

int TSPGraph::getNumCities() const {
  return m_cities.size();
}

const City & TSPGraph::getCity(int index) const {
  return m_cities[index];
}

const std::vector<City> & TSPGraph::getCities() const {
  return m_cities;
}

const double * TSPGraph::operator [] (int i) const {
  return &m_distanceMatrix[i * m_numCities];
}

double * TSPGraph::operator [] (int i) {
  return &m_distanceMatrix[i * m_numCities];
}
