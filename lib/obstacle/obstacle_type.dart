// Ignoring any unused elements for linting purposes.
// ignore_for_file: unused_element

import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

///
/// This code defines a class ObstacleTypeSettings that holds configurations
/// for different obstacle types in the game.
///
/// These configurations include the size, position, when the obstacle can
/// appear, the minimum gap between them, hitbox settings for collision
/// detection, and more.
///
/// There are also predefined settings for two types of cacti: small and large.
///

// Enum to define the different types of obstacles.
enum ObstacleType {
  cactusSmall,
  cactusLarge,
}

class ObstacleTypeSettings {
  // Internal constructor to initialize the settings for each type of obstacle.
  const ObstacleTypeSettings._internal(
    this.type, {
    required this.size,
    required this.y,
    required this.allowedAt,
    required this.multipleAt,
    required this.minGap,
    required this.minSpeed,
    required this.generateHitboxes,
  });

  final ObstacleType type; // Type of the obstacle.
  final Vector2 size; // Size of the obstacle.
  final double y; // Y-axis position of the obstacle.
  final int allowedAt; // When the obstacle is allowed to appear.
  final int multipleAt; // When multiple instances of the obstacle can appear.
  final double minGap; // Minimum gap between the obstacles.
  final double minSpeed; // Minimum speed for the obstacle to appear.

  static const maxGroupSize =
      3.0; // Max number of obstacles that can appear together.

  final List<ShapeHitbox> Function()
      generateHitboxes; // Function to generate hitboxes for collision detection.

  // Configuration for small cactus type.
  static final cactusSmall = ObstacleTypeSettings._internal(
    ObstacleType.cactusSmall,
    size: Vector2(34.0, 70.0),
    y: -55.0,
    allowedAt: 0,
    multipleAt: 1000,
    minGap: 120.0,
    minSpeed: 0.0,
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        position: Vector2(0.0, 0.0),
        size: Vector2(34.0, 70.0),
      ),
    ],
  );

  // Configuration for large cactus type.
  static final cactusLarge = ObstacleTypeSettings._internal(
    ObstacleType.cactusLarge,
    size: Vector2(50.0, 100.0),
    y: -74.0,
    allowedAt: 800,
    multipleAt: 1500,
    minGap: 120.0,
    minSpeed: 0.0,
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        position: Vector2(0.0, 0.0),
        size: Vector2(50.0, 100.0),
      ),
    ],
  );

  // Fetch the sprite image for the respective obstacle type.
  Sprite sprite(Image spriteImage) {
    switch (type) {
      case ObstacleType.cactusSmall:
        return Sprite(
          spriteImage,
          srcPosition: Vector2(446.0, 2.0),
          srcSize: size,
        );
      case ObstacleType.cactusLarge:
        return Sprite(
          spriteImage,
          srcPosition: Vector2(652.0, 2.0),
          srcSize: size,
        );
    }
  }
}
