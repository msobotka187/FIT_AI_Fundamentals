# 🌀 Labyrinth Solver & Pathfinding Visualizer

A Python-based CLI tool that parses grid-based labyrinths and visualizes pathfinding algorithms using a custom **RGB Heatmap**. This project demonstrates the efficiency and behavior of different search strategies through terminal graphics.

## ✨ Features

* **Interactive CLI**: Select your file and algorithm via a numbered menu.
* **RGB Heatmap Visualization**:
    * **Search Process**: Visualized with a gradient from **Turquoise** (early discovery) to **Magenta** (late discovery).
    * **Final Path**: Overlayed with a high-contrast **Yellow-to-Orange** gradient.
* **Performance Metrics**: Automatically calculates **Nodes Expanded** (efficiency) and **Path Length** (optimality).
* **Safety Thresholds**: Detects large mazes and prompts for confirmation to prevent terminal lag or incorrect visualization.

## 🛠 Supported Algorithms

1.  **BFS (Breadth-First Search)**: Explores in even "waves" to guarantee the shortest path.
2.  **DFS (Depth-First Search)**: Dives deep into branches.
3.  **A* (A-Star)**: Uses Manhattan distance heuristics to "aim" efficiently at the goal.
4.  **Greedy Best-First Search**: Focuses solely on moving closer to the exit.
5.  **Random Search**: Explores the labyrinth without a fixed strategy.

## 📋 Requirements & Dependencies

* **Python 3.10+**
* **Rich Library**: Used for the advanced terminal rendering and RGB support.

## 🚀 How to Run

Follow these steps to explore and visualize the pathfinding algorithms:

1. **Prepare your Maze**: Place your labyrinth `.txt` file into the `dataset/` or `testovaci_data/` folder. You can also use the pre-loaded default mazes.
2. **Execute the Solver**: Run the main.py script from your terminal
3. **Select a File:** When prompted, enter the number corresponding to your chosen maze.
4. **Choose an Algorithm:** Select pathfinding strategy you wish to visualize
5. **Analyze the Result:** Enjoy the high-resolution heatmap visualization and compare performance statistics!

## 🎨 Color Legend

| Element | Visualization | Description |
| :--- | :--- | :--- |
| **Start/End** | **`S` / `E`** | Green 'S' for start, Red 'E' for exit. |
| **Early Discovery** | **`#00FFF0` Turquoise** | Nodes explored at the beginning of the search. |
| **Mid Discovery** | **`#0000FF` Blue** | Transition phase of the search algorithm. |
| **Late Discovery** | **`#FF00FF` Magenta** | Nodes explored as the algorithm reached its limit. |
| **Final Path** | **`#FFFF00` Yellow** | The actual solution found (Start of path). |
| **Final Path** | **`#FF1E00` Orange** | The actual solution found (End of path). |
| **Unvisited** | **`#2A2A2A` Grey** | Walkable paths that were never expanded. |
| **Walls** | **`#FFFFFF` White** | Non-traversable boundaries. |
