#include "City.h"

#include <cmath>

City::City(int id, double x, double y) : m_id(id), m_x(x), m_y(y) {}

int    City::getId() const { return m_id; }
double City::getX()  const { return m_x; }
double City::getY()  const { return m_y; }

// Euclid distance
double City::distanceTo(const City & other) const {
  double dx = this->m_x - other.m_x;
  double dy = this->m_y - other.m_y;

  return std::sqrt(dx*dx + dy*dy);
}
