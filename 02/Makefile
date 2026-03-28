CXX = g++
CXXFLAGS = -std=c++20 -Wall -pedantic -Wno-long-long -O2 -c -Werror

LDFLAGS = # TODO

TARGET = main

SRCS = main.cpp City.cpp TSPGraph.cpp SimulatedAnnealing.cpp Visualizer.cpp

OBJS = $(SRCS:.cpp=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJS) $(TARGET)
