import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

//Base class for all our sprites
class Character extends SpriteAnimationComponent with CollisionCallbacks {
  Character(
      {required Vector2 position,
      required Vector2 size,
      required double speed}) {
    this.position = position;
    this.size = size;
    this.speed = speed;
  }

  late SpriteAnimation downAnimation,
      leftAnimation,
      upAnimation,
      rightAnimation;
  late double speed;
  double elapsedTime = 0.0;
  int currentDirection = down;
  static const int down = 0, left = 1, up = 2, right = 3;

  void changeDirection() {
    Random random = Random();
    int newDirection = random.nextInt(4);

    switch (newDirection) {
      case down:
        animation = downAnimation;
        break;
      case left:
        animation = leftAnimation;
        break;
      case up:
        animation = upAnimation;
        break;
      case right:
        animation = rightAnimation;
        break;
    }

    currentDirection = newDirection;
  }

  @override
  void update(double deltaTime) {
    super.update(deltaTime);

    elapsedTime += deltaTime;
    if (elapsedTime > 3.0) {
      changeDirection();
      elapsedTime = 0.0;
    }

    switch (currentDirection) {
      case down:
        position.y += speed * deltaTime;
        break;
      case left:
        position.x -= speed * deltaTime;
        break;
      case up:
        position.y -= speed * deltaTime;
        break;
      case right:
        position.x += speed * deltaTime;
        break;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);

    if (other is ScreenHitbox) {
      switch (currentDirection) {
        case down:
          currentDirection = up;
          animation = upAnimation;
          break;
        case left:
          currentDirection = right;
          animation = rightAnimation;
          break;
        case up:
          currentDirection = down;
          animation = downAnimation;
          break;
        case right:
          currentDirection = left;
          animation = leftAnimation;
          break;
      }

      elapsedTime = 0.0;
    }
  }
}

extension CreateAnimationByColumn on SpriteSheet {
  SpriteAnimation createAnimationByColumn({
    required int column,
    required double stepTime,
    bool loop = true,
    int from = 0,
    int? to,
  }) {
    to ??= columns;

    List<int>.generate(to - from, (i) => from + i)
        .map((e) => getSprite(e, column))
        .toList();

    return SpriteAnimation.fromFrameData(
      getSprite(0, 0).image,
      SpriteAnimationData.sequenced(
        amount: columns,
        amountPerRow: 1,
        stepTime: stepTime,
        textureSize: Vector2(columns.toDouble(), rows.toDouble()),
        loop: loop,
      ),
    );
  }
}
