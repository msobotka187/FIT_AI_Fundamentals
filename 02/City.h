#ifndef CITY_H
#define CITY_H

class City {
public:
  // Constructors
  City(int id, double x, double y);

  // Getters
  int    getId() const;
  double getX()  const;
  double getY()  const;

  // Logic Functions
  double distanceTo(const City & other) const;

private:
  int m_id;
  double m_x;
  double m_y;
};

#endif // CITY_H
