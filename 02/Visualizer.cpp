#include "Visualizer.h"
#include <raylib.h>
#include <string>

Visualizer::Visualizer(
    const TSPGraph & graph,
    SimulatedAnnealing & sa,
    int width,
    int height
)
  : m_graph(graph),
    m_sa(sa),
    m_width(width),
    m_height(height)
{}

bool Visualizer::run() {
  float btnWidth   = 100.0f;
  float btnHeight  = 30.0f;
  float btnMarginY = 20.0f;

  Rectangle btnBounds = {
    (m_width / 2.0f) - (btnWidth / 2.0f), m_height - btnMarginY - btnHeight,
    btnWidth, btnHeight
  };

  // Run until user closes the window
  while (!WindowShouldClose()) {
    Vector2 mousePos = GetMousePosition();
    bool isHovered = CheckCollisionPointRec(mousePos, btnBounds);

    // Button pressed or `R` key is pressed - reset
    if ((isHovered && IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) || IsKeyPressed(KEY_R)) {
      EndDrawing();
      return true;  // Inside main we reset the loop
    }

    // If not on minTemp, do a step
    if (!m_sa.isDone()) {
      m_sa.step();
    }

    // Draw right after that
    draw(isHovered);
  }

  return false; // User closed the window
}

void Visualizer::draw(bool isBtnHovered) {
  BeginDrawing();
  ClearBackground(DARKGRAY);

  // Drawing of the current route
  if (!m_sa.isDone()) {
    const auto & currRoute = m_sa.getCurrRoute();
    for (size_t i = 0; i < currRoute.size(); i++) {
      int cityA = currRoute[i];
      int cityB = currRoute[(i + 1) % currRoute.size()];

      DrawLine(
          (int)m_graph.getCity(cityA).getX(), (int)m_graph.getCity(cityA).getY(),
          (int)m_graph.getCity(cityB).getX(), (int)m_graph.getCity(cityB).getY(),
          RAYWHITE
      );
    }
  }

  // Drawing of the best route
  const auto & bestRoute = m_sa.getBestRoute();
  for (size_t i = 0; i < bestRoute.size(); i++) {
    int cityA = bestRoute[i];
    int cityB = bestRoute[(i + 1) % bestRoute.size()];

    DrawLineEx(
      {(float)m_graph.getCity(cityA).getX(), (float)m_graph.getCity(cityA).getY()},
      {(float)m_graph.getCity(cityB).getX(), (float)m_graph.getCity(cityB).getY()},
      2.0f, LIME
    );
  }

  // Drawing of the cities
  for (const auto & city : m_graph.getCities()) {
    DrawCircle((int)city.getX(), (int)city.getY(), 4.0f, BLUE);
  }

  // Print statistics to the corner
  DrawText(TextFormat("Temperature: %.2f", m_sa.isDone() ? m_sa.getMinTemp() : m_sa.getCurrTemp()), 10, 10, 20, RAYWHITE);
  DrawText(TextFormat("Best Distance: %.2f", m_sa.getBestDistance()), 10, 35, 20, LIME);

  if (m_sa.isDone()) {
    DrawText("DONE!", 10, 60, 20, RED);
  }

  // Draw the reset button
  // TODO: create a file for these constants
  float btnWidth   = 100.0f;
  float btnHeight  = 30.0f;
  float btnMarginY = 20.0f;
  float btnCenterX = (m_width / 2.0f);
  float btnCenterY = m_height - btnMarginY - (btnHeight / 2.0f);

  Rectangle btnBounds = {
    (m_width / 2.0f) - (btnWidth / 2.0f), m_height - btnMarginY - btnHeight,
    btnWidth, btnHeight
  };

  Color btnColor = isBtnHovered ? LIGHTGRAY : GRAY;

  DrawRectangleRec(btnBounds, btnColor);
  DrawRectangleLinesEx(btnBounds, 2.0f, BLACK); // Outline

  float fontSize = 15.0f;
  DrawText("Restart (R)", btnCenterX - fontSize, btnCenterY - fontSize, fontSize, BLACK);

  EndDrawing();
}
