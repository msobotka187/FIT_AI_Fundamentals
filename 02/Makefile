CXX = g++
CXXFLAGS = -std=c++20 -Wall -pedantic -Wno-long-long -O2 -Werror

TARGET = main

LDFLAGS = -lraylib -lGL -lm -lpthread -ldl -lrt -lX11

SRCS = main.cpp Constants.cpp City.cpp TSPGraph.cpp SimulatedAnnealing.cpp Visualizer.cpp

OBJS = $(SRCS:.cpp=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS) $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf $(OBJS) $(TARGET)

