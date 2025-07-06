import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/palette.dart';

class Player extends PositionComponent {
  static const int squareSpeed = 250;
  static final squarePaint = BasicPalette.green.paint();
  static final squareWidth = 100.0, squareHeight = 100.0;

  int squareDirection = 1;
  late double screenWidth, screenHeight, centerX, centerY;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final view = PlatformDispatcher.instance.views.first;
    screenWidth = MediaQueryData.fromView(view).size.width;
    screenHeight = MediaQueryData.fromView(view).size.height;

    centerX = (screenWidth / 2) - (squareWidth / 2);
    centerY = (screenHeight / 2) - (squareHeight / 2);

    position = Vector2(centerX, centerY);
    size = Vector2(squareWidth, squareHeight);
  }

  @override
  void update(double deltaTime) {
    super.update(deltaTime);
    position.x += squareSpeed * squareDirection * deltaTime;

    // Detect collision with left or right screen edge and call onCollision
    if (position.x <= 0) {
      position.x = 0;
      onCollision({position.clone()}, 'left');
    } else if (position.x + size.x >= screenWidth) {
      position.x = screenWidth - size.x;
      onCollision({position.clone()}, 'right');
    }
  }

  // Now handle the direction flip inside onCollision
  void onCollision(Set<Vector2> points, dynamic other) {
    if (other == 'left' || other == 'right') {
      squareDirection *= -1;
    }
    // Implement other collision logic here if needed
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), squarePaint);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    screenWidth = gameSize.x;
    screenHeight = gameSize.y;
  }
}
