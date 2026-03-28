#ifndef CITY_H
#define CITY_H

class City {
public:
  // Constructors
  City(int id, double x, double y);

  // Getters
  int    getId() const return { m_id; };
  double getX()  const return { m_x; };
  double getY()  const return { m_y; };

  // Logic Functions
  double distanceTo(const City & other) const;

private:
  int m_id;
  double m_x;
  double m_y;
};

#endif // CITY_H
