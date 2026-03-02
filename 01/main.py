#!/bin/python3

# imports
from pathlib import Path
from itertools import chain
from rich import print as rprint
from rich.console import Console
import collections
import heapq
import random


# Constants that work for my laptop
ROWS_THRESHOLD = 150
COLS_THRESHOLD = 200

def read_data(file_path) -> str:
    with open(file_path, 'r', encoding="utf-8") as f:
        data = f.read()
    return data

class Graph:
    def __init__(self):
        self.vertices = []   # List of (x, y) tuples
        self.neighbors = {}  # Dictionary: {(x, y): [(nx, ny), ...]}
        self.start = tuple() # (x, y) tuple
        self.end = tuple()   # (x, y) tuple

    def add_vertex(self, x, y) -> None:
        if (x, y) not in self.neighbors:
            self.vertices.append((x, y))
            self.neighbors[(x, y)] = []

    def add_edge(self, v1, v2) -> None:
        if v2 not in self.neighbors[v1]:
            self.neighbors[v1].append(v2)
        if v1 not in self.neighbors[v2]:
            self.neighbors[v2].append(v1)

def data_to_graph(data_string) -> tuple[Graph, int, int]:
    lines = [line.rstrip() for line in data_string.strip().split('\n')]
    graph = Graph()
    grid_lines = []

    for line in lines:
        if line.startswith("start"):
            coords = line.replace("start", "").strip().split(",")
            graph.start = (int(coords[0]), int(coords[1]))
        elif line.startswith("end"):
            coords = line.replace("end", "").strip().split(",")
            graph.end = (int(coords[0]), int(coords[1]))
        # Only add to grid if it looks like the maze part (contains 'X' or ' ')
        elif any(char in line for char in "X "):
            grid_lines.append(line)

    # Calculate dimensions
    rows = len(grid_lines)
    cols = max(len(line) for line in grid_lines) if rows > 0 else 0

    # 1. Identify all walkable vertices (' ')
    for y, line in enumerate(grid_lines):
        for x, char in enumerate(line):
            if char == ' ':
                graph.add_vertex(x, y)

    # 2. Build neighbor list
    for (x, y) in graph.vertices:
        # Only check Right and Down to avoid double adding
        for dx, dy in [(1, 0), (0, 1)]:
            neighbor = (x + dx, y + dy)
            if neighbor in graph.neighbors:
                graph.add_edge((x, y), neighbor)

    return graph, rows, cols


def reconstruct_path(parents, end):
    path = []
    curr = end
    while curr is not None:
        path.append(curr)
        curr = parents[curr]
    return path[::-1]

def random_search(graph):
    stack = [graph.start]
    parents = {graph.start: None}
    visited_order = {}
    visited = set()
    step_count = 0

    while stack:
        # Pick a random index and swap it to the end to pop it
        idx = random.randrange(len(stack))
        stack[idx], stack[-1] = stack[-1], stack[idx]
        curr = stack.pop()

        if curr in visited:
            continue

        visited.add(curr)
        visited_order[curr] = step_count
        step_count += 1

        if curr == graph.end:
            return reconstruct_path(parents, graph.end), visited_order

        for neighbor in graph.neighbors.get(curr, []):
            if neighbor not in visited:
                parents[neighbor] = curr
                stack.append(neighbor)

    return None, visited_order

def dfs(graph):
    stack = [graph.start]
    parents = {graph.start: None}
    visited_order = {}
    visited = set()
    step_count = 0

    while stack:
        curr = stack.pop()

        if curr in visited:
            continue

        visited.add(curr)
        visited_order[curr] = step_count
        step_count += 1

        if curr == graph.end:
            return reconstruct_path(parents, graph.end), visited_order

        for neighbor in graph.neighbors.get(curr, []):
            if neighbor not in visited:
                parents[neighbor] = curr
                stack.append(neighbor)

    return None, visited_order

def bfs(graph):
    queue = collections.deque([graph.start])
    parents = {graph.start: None}
    visited_order = {}
    step_count = 0

    while queue:
        curr = queue.popleft()
        if curr not in visited_order:
            visited_order[curr] = step_count
            step_count += 1

        if curr == graph.end:
            return reconstruct_path(parents, graph.end), visited_order

        for neighbor in graph.neighbors.get(curr, []):
            if neighbor not in parents:
                parents[neighbor] = curr
                queue.append(neighbor)
    return None, visited_order

def greedy_search(graph):
    def heuristic(a, b):
        # Manhattan distance
        return abs(a[0] - b[0]) + abs(a[1] - b[1])

    # Priority queue stores (priority, coordinate)
    pq = [(0, graph.start)]
    parents = {graph.start: None}
    visited_order = {}
    visited = set()
    step_count = 0

    while pq:
        # Pop the node with the lowest heuristic value
        _, curr = heapq.heappop(pq)

        if curr in visited:
            continue

        visited.add(curr)
        visited_order[curr] = step_count
        step_count += 1

        if curr == graph.end:
            return reconstruct_path(parents, graph.end), visited_order

        for neighbor in graph.neighbors.get(curr, []):
            if neighbor not in visited:
                parents[neighbor] = curr
                # Priority is just the distance to the end
                priority = heuristic(neighbor, graph.end)
                heapq.heappush(pq, (priority, neighbor))

    return None, visited_order

def a_star(graph):
    def heuristic(a, b):
        # Manhattan distance
        return abs(a[0] - b[0]) + abs(a[1] - b[1])

    open_pq = []
    dist = {graph.start: 0}
    prev = {graph.start: None}
    closed = set()

    visited_order = {}
    step_count = 0

    heapq.heappush(open_pq, (heuristic(graph.start, graph.end), graph.start))

    while open_pq:
        _, x = heapq.heappop(open_pq)

        if x in closed:
            continue

        visited_order[x] = step_count
        step_count += 1

        if x == graph.end:
            return reconstruct_path(prev, graph.end), visited_order

        for y in graph.neighbors.get(x, []):
            if y in closed:
                continue

            d0 = dist[x] + 1

            if y not in dist or d0 < dist[y]:
                dist[y] = d0
                prev[y] = x

                heapq.heappush(open_pq, (d0 + heuristic(y, graph.end), y))

        closed.add(x)

    return None, visited_order

def print_labyrinth(text_form) -> None:
    lines = [line.rstrip() for line in text_form.strip().split('\n')]

    # --- Print 's' and 'e' ---
    start = lines[-2].replace("start", "").strip().split(", ")
    end   = lines[-1].replace("end",   "").strip().split(", ")

    s_row, s_col = int(start[1]), int(start[0])
    e_row, e_col = int(end[1]), int(end[0])

    row_s = list(lines[s_row])
    row_s[s_col] = "s"
    lines[s_row] = "".join(row_s)

    row_e = list(lines[e_row])
    row_e[e_col] = "e"
    lines[e_row] = "".join(row_e)
    # ------------------------

    for line in lines[:-2]:
        print(line)

def get_heatmap_color(step, total_steps) -> str:
    if total_steps < 0: raise ValueError("Total steps cannot be negative")
    if total_steps == 0: return "rgb(0,255,240)"

    # Normalize step to a 0-1 scale
    t = step / total_steps

    if t < 0.5:
        # Interpolate Turquoise to Blue
        # (0, 255, 240) -> (0, 0, 255)
        factor = t * 2
        r = 0
        g = int(255 * (1 - factor))
        b = int(240 + (15 * factor))
    else:
        # Interpolate Blue to Magenta
        # (0, 0, 255) -> (255, 0, 255)
        factor = (t - 0.5) * 2
        r = int(255 * factor)
        g = 0
        b = 255

    return f"rgb({r},{g},{b})"

def print_solved(graph, visited_order, final_path=None) -> None:
    if not graph.vertices: return

    # Calculate bounds
    max_x = max(v[0] for v in graph.vertices) + 2
    max_y = max(v[1] for v in graph.vertices) + 2

    # Create a lookup for the path position to calculate its gradient
    path_indices = {pos: i for i, pos in enumerate(final_path)} if final_path else {}
    total_path_steps = len(final_path) if final_path else 1
    total_visited_steps = max(visited_order.values()) if visited_order else 1

    for y in range(max_y):
        line = ""
        for x in range(max_x):
            curr = (x, y)

            if curr == graph.start:
                line += "[bold green]S[/]"
            elif curr == graph.end:
                line += "[bold red]E[/]"

            # 1. Final Path Gradient (Yellow -> Orange/Gold)
            elif curr in path_indices:
                step = path_indices[curr]
                t = step / max(total_path_steps, 1)

                # Interpolating Yellow (255, 255, 0) to Orange (255, 30, 0)
                r, g, b = 255, int(255 - ((255 - 30) * t)), 0
                path_color = f"rgb({r},{g},{b})"
                line += f"[bold {path_color}]█[/]"

            # 2. Visited Heatmap (Turquoise -> Magenta)
            elif curr in visited_order:
                color = get_heatmap_color(visited_order[curr], total_visited_steps)
                line += f"[{color}]░[/]"

            # 3. Walkable but unvisited (Red background as requested)
            elif curr in graph.neighbors:
                line += "[rgb(42,42,42)]█[/]"

            # 4. Walls
            else:
                line += "[white on white] [/]"

        rprint(line)

    # --- Print Statistics ---
    print()
    rprint("-" * 30)
    rprint(f"[bold cyan]Nodes Expanded: {len(visited_order)}[/]")
    if final_path:
        rprint(f"[bold green]Path Length:    {len(final_path)}[/]")
    else:
        rprint("[bold red]Path Length:    N/A (No path found)[/]")
    rprint("-" * 30)


def main() -> None:
    dataset = Path("dataset")
    testovaci_data = Path("testovaci_data/")

    # 1. Choose the file
    all_files = list(chain(dataset.glob("*.txt"), testovaci_data.glob("*.txt")))
    if not all_files:
        rprint("[bold red]No .txt files found![/]")
        return

    rprint("[bold cyan]Available files:[/]")
    for i, f in enumerate(all_files):
        print(f"{i+1}: {f.name}")

    file_choice = input(f"\nSelect file (1-{len(all_files)}): ")
    try:
        file_choice = int(file_choice)
    except ValueError:
        rprint(f"[bold red]Input is not a number[/]")
        return

    if file_choice < 1 or file_choice > len(all_files):
        rprint(f"[bold red]File choice is out of range[/]")
        return

    file_path = all_files[file_choice - 1]

    # 2. Select Algorithm
    algos = [
        ("BFS", bfs),
        ("DFS", dfs),
        ("A*", a_star),
        ("Greedy", greedy_search),
        ("Random", random_search)
    ]

    rprint("\n[bold cyan]Select Algorithm:[/]")
    for i, (name, _) in enumerate(algos):
        print(f"{i+1}: {name}")

    algo_choice = input("\nChoice (1-5): ")
    try:
        algo_choice = int(algo_choice)
    except ValueError:
        rprint(f"[bold red]Input is not a number[/]")
        return

    if algo_choice < 1 or algo_choice > 5:
        rprint(f"[bold red]Algorithm choice is out of range[/]")
        return

    algo_name, algo_func = algos[algo_choice - 1]

    # 3. Process and Run
    file_data = read_data(file_path)
    graph, rows, cols = data_to_graph(file_data)

    rprint(f"\n[bold cyan]RUNNING {algo_name} ON {file_path.name} [/]")

    path, order = algo_func(graph)

    if rows <= ROWS_THRESHOLD and cols <= COLS_THRESHOLD:
        print_solved(graph, order, path)
    else:
        rprint(f"\n[orange1 bold]WARNING: Maze is too large to display ({rows}x{cols})[/]")
        choice = input("Do You want to display the Maze anyway? (y/N): ").lower().strip()

        if choice == 'y':
            print_solved(graph, order, path)
        else:
            # Even if we don't print the maze, we should still see the stats!
            rprint("[bold cyan]\nSkipping visual display\n[/]")
            rprint("-" * 30)
            rprint(f"[bold cyan]Nodes Expanded:[/] {len(order)}")
            if path:
                rprint(f"[bold green]Path Length:[/]    {len(path)}")
            else:
                rprint("[bold red]Path Length:    N/A (No path found)[/]")
                rprint("-" * 30)


# Run the program
if __name__ == "__main__":
    main()
