import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Background extends PositionComponent {
  static final backgroundPaint =
      BasicPalette.white.paint(); // The color of the background
  late double screenWidth, screenHeight;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Get the width and height of our screen canvas
    screenWidth = MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first)
        .size
        .width;
    screenHeight = MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first)
        .size
        .height;

    position = Vector2(0, 0);
    size = Vector2(screenWidth, screenHeight);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRect(
        Rect.fromPoints(position.toOffset(), size.toOffset()), backgroundPaint);
  }
}
