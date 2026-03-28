#include <City.h>
#include <cmath>

City::City(int id, double x, double y) : m_id(id), m_x(x), m_y(y) {}

// Euklid distance
double City::distanceTo(const City & other) const {
  double dx = this->x - other.x;
  double dy = this->y - other.y;

  return std::sqrt(dx*dx + dy*dy);
}
