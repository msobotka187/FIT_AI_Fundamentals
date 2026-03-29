#include "Visualizer.h"
#include "Constants.h"

#include <raylib.h>
#include <string>

Visualizer::Visualizer(const TSPGraph & graph, SimulatedAnnealing & sa) : m_graph(graph), m_sa(sa) {}

bool Visualizer::run() {
  Rectangle btnBounds = Constants::BTN_BOUNDS;

  // Run until user closes the window
  while (!WindowShouldClose() && !IsKeyPressed(KEY_Q)) {
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
  ClearBackground(Constants::BACKGROUND_COLOR);

  // Drawing of the current route
  if (!m_sa.isDone()) {
    const auto & currRoute = m_sa.getCurrRoute();
    for (size_t i = 0; i < currRoute.size(); i++) {
      int cityA = currRoute[i];
      int cityB = currRoute[(i + 1) % currRoute.size()];

      DrawLine(
          (int)m_graph.getCity(cityA).getX(), (int)m_graph.getCity(cityA).getY(),
          (int)m_graph.getCity(cityB).getX(), (int)m_graph.getCity(cityB).getY(),
          Constants::CURR_ROUTE_COLOR
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
      Constants::BEST_ROUTE_WIDTH, Constants::BEST_ROUTE_COLOR
    );
  }

  // Drawing of the cities
  for (const auto & city : m_graph.getCities()) {
    DrawCircle(
        (int)city.getX(),
        (int)city.getY(),
        Constants::CITY_CIRCLE_WIDTH,
        Constants::CITY_COLOR
    );
  }

  // Print statistics to the corner
  DrawText(
      TextFormat("Temperature: %.2f", m_sa.isDone() ? m_sa.getMinTemp() : m_sa.getCurrTemp()),
      Constants::TEMP_TEXT_X,
      Constants::TEMP_TEXT_Y,
      Constants::TEMP_FONT_SIZE,
      Constants::TEMP_TEXT_COLOR
  );
  DrawText(
      TextFormat("Best Distance: %.2f", m_sa.getBestDistance()),
      Constants::DIST_TEXT_X,
      Constants::DIST_TEXT_Y,
      Constants::DIST_FONT_SIZE,
      Constants::DIST_TEXT_COLOR
  );

  if (m_sa.isDone()) {
    DrawText(
        "DONE!",
        Constants::DONE_TEXT_X,
        Constants::DONE_TEXT_Y,
        Constants::DONE_FONT_SIZE,
        Constants::DONE_TEXT_COLOR
    );
  }

  // Draw the reset button
  Rectangle btnBounds = Constants::BTN_BOUNDS;

  Color btnColor = isBtnHovered ? Constants::BTN_HOVERED_COLOR : Constants::BTN_UNHOVERED_COLOR;

  DrawRectangleRec(btnBounds, btnColor);
  DrawRectangleLinesEx(btnBounds, Constants::BTN_OUTLINE_WIDTH, Constants::BTN_OUTLINE_COLOR);

  int    BTN_TEXT_WIDTH = MeasureText(Constants::BTN_TEXT, Constants::BTN_FONT_SIZE);
  float  BTN_TEXT_X     = Constants::BTN_START_X + (Constants::BTN_WIDTH  / 2.0f) - (BTN_TEXT_WIDTH / 2.0f);
  float  BTN_TEXT_Y     = Constants::BTN_START_Y + (Constants::BTN_HEIGHT / 2.0f) - (Constants::BTN_FONT_SIZE  / 2.0f);

  DrawText(
      Constants::BTN_TEXT,
      BTN_TEXT_X,
      BTN_TEXT_Y,
      Constants::BTN_FONT_SIZE,
      Constants::BTN_TEXT_COLOR
  );

  EndDrawing();
}
