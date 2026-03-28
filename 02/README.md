# 🌍 Traveling Salesman Problem (TSP) Visualizer

A high-performance C++ tool that solves the **Symmetric Traveling Salesman Problem** using the **Simulated Annealing** algorithm. This project features a real-time visualization powered by **Raylib**, allowing you to watch the algorithmic "cooling" process as it untangles chaotic paths into highly optimized routes.

## ✨ Features
* **Real-Time Animation**: Watch the algorithm dynamically untangle crossing paths in a smooth 60 FPS window.
* **Highly Optimized Backend**:
  * Uses a flat **1D array** mapped as a 2D distance matrix for L1 cache-friendly lookups.
  * Implements an **$O(1)$ delta distance calculation** for the 2-opt swap, allowing hundreds of thousands of iterations per second without recalculating the entire route.
* **Live Metrics**: Real-time on-screen display of the current annealing temperature and the shortest distance found.
* **Smart Bounds**: Cities are automatically generated with dynamic padding to fit perfectly within the window frame.

## 🛠 The Algorithm (Simulated Annealing)
1. **Initial State**: Generates a completely random permutation of cities.
2. **2-opt Exchange**: Modifies the route by reversing random sub-paths. This is exceptionally effective at removing intersections in Euclidean space.
3. **Metropolis Criterion**: Evaluates the new state. It strictly accepts *shorter* paths, but probabilistically accepts *worse* paths at high temperatures to escape local minima.
4. **Geometric Cooling**: Gradually decreases the system's temperature $(T_{k+1} = \alpha \cdot T_k)$ until the "metal freezes" into an optimal or near-optimal state.

## 📋 Requirements & Dependencies
* **C++ Compiler**: `g++`, version C++20
* **Make**: Build automation tool.
* **Raylib**: A simple and easy-to-use library to enjoy video games programming (used for 2D rendering).

## 🚀 How to Run
Works on **Windows**/**Linux**
Follow these steps to compile and launch the visualization:

1. **Install Raylib**: Ensure Raylib is installed on your system [github](https://github.com/raysan5/raylib).
2. **Compile the Project**: Open your terminal in the project directory and run the `make run` command to build and run the executable.

