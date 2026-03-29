#ifndef TSPGRAPH_H
#define TSPGRAPH_H

#include <vector>
#include "City.h"

class TSPGraph {
public:
  // Constructors
  TSPGraph(int numCities);

  // Getters
  double getDistance(int from, int to) const;
  int getNumCities() const;
  const City & getCity(int index) const;
  const std::vector<City> & getCities() const;

  // Overloading [] so that we can index array as if it was matrix
  // The first [] will return start of the row
  // The second [] will then return the actual element
  const double * operator [] (int i) const;
  double * operator [] (int i);


private:
  int m_numCities;
  std::vector<City> m_cities;
  std::vector<double> m_distanceMatrix; // 1D Array but it's actually a Matrix

  void precomputeDistanceMatrix();
};

#endif // TSPGRAPH_H
