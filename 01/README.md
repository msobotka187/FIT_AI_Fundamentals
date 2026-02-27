# 🌀 Labyrinth Solver & Pathfinding Visualizer

A Python-based CLI tool that parses grid-based labyrinths and visualizes pathfinding algorithms using a custom **RGB Heatmap**. This project demonstrates the efficiency and behavior of different search strategies through terminal graphics.

## 🚀 Features

* **Interactive CLI**: Select your file and algorithm via a numbered menu.
* **RGB Heatmap Visualization**:
    * **Search Process**: Visualized with a gradient from **<span style="color: #40E0D0;">Turquoise</span>** (early discovery) to **<span style="color: #FF00FF;">Magenta</span>** (late discovery).
    * **Final Path**: Overlayed with a high-contrast **Yellow-to-Orange** gradient.
* **Performance Metrics**: Automatically calculates **Nodes Expanded** (efficiency) and **Path Length** (optimality).
* **Safety Thresholds**: Detects large mazes and prompts for confirmation to prevent terminal lag.

## 🛠 Supported Algorithms

1.  **BFS (Breadth-First Search)**: Explores in even "waves" to guarantee the shortest path.
2.  **DFS (Depth-First Search)**: Dives deep into branches; moves like a winding snake.
3.  **A* (A-Star)**: Uses Manhattan distance heuristics to "aim" efficiently at the goal.
4.  **Greedy Best-First Search**: Focuses solely on moving closer to the exit.
5.  **Random Search**: Explores the labyrinth without a fixed strategy.

## 📋 Requirements & Dependencies

* **Python 3.10+**
* **Rich Library**: Used for the advanced terminal rendering and RGB support.

To install the necessary dependency, run:
```bash
pip install rich
```

| Element | Visualization | Description |
| :--- | :--- | :--- |
| **Start/End** | **`S` / `E`** | Green 'S' for start, Red 'E' for exit. |
| **Early Discovery** | **<span style="color: #40E0D0;">░ Turquoise</span>** | Nodes explored at the beginning of the search. |
| **Late Discovery** | **<span style="color: #FF00FF;">░ Magenta</span>** | Nodes explored as the algorithm progressed. |
| **Final Path** | **<span style="color: #FFA500;">█ Orange</span>** | The actual solution found by the algorithm. |
| **Unvisited** | **<span style="color: #FF0000;">█ Red</span>** | Walkable paths that were never expanded. |
