// Importing necessary packages and local modules.
import 'package:flame/components.dart';
import 'package:trex_final_game/obstacle/obstacle_type.dart';
import 'package:trex_final_game/utils/random_extension.dart';

import '../trex_game_manager.dart';

///
/// This code provides a definition for an obstacle in a game.
/// The obstacle's position, size, and other properties are adjusted based on
/// the game's speed and specific obstacle settings.
///
/// It calculates the distance between obstacles and updates their position
/// over time. If an obstacle goes off-screen, it's removed to
/// optimize performance.

// The Obstacle class defines each obstacle object that the player will encounter and possibly jump over.
class Obstacle extends SpriteComponent with HasGameRef<TRexGameManager> {
  // Constructor that initializes the Obstacle with required parameters like the type and group index.
  Obstacle({
    required this.settings,
    required this.groupIndex,
  }) : super(size: settings.size);

  @override
  bool debugMode = false;

  // Coefficient for determining the distance between obstacles.
  final double _gapCoefficient = 0.6;
  final double _maxGapCoefficient = 1.5;

  // Flag to determine if the subsequent obstacle has been created.
  bool followingObstacleCreated = false;
  // Distance between this obstacle and the next.
  late double gap;
  // Configuration of the current obstacle type.
  final ObstacleTypeSettings settings;
  // Index of the obstacle in a group (useful if multiple obstacles are close to each other).
  final int groupIndex;

  // Property to determine if the obstacle is currently visible on the screen.
  bool get isVisible => (x + width) > 0;

  @override
  Future<void> onLoad() async {
    // Load the sprite image for the obstacle.
    sprite = settings.sprite(gameRef.spriteImage);
    // Position the obstacle horizontally based on the game screen size and its index within the group.
    x = gameRef.size.x + width * groupIndex;
    // Set the vertical position based on the settings of the obstacle type.
    y = settings.y;
    // Calculate the distance between this obstacle and the next, based on game speed and gap coefficients.
    gap = computeGap(_gapCoefficient, gameRef.currentSpeed);
    // add obstacle hitboxes
    addAll(settings.generateHitboxes());
  }

  // Calculate the gap or distance between the current obstacle and the next.
  double computeGap(double gapCoefficient, double speed) {
    // Minimum gap between obstacles.
    final minGap =
        (width * speed * settings.minGap * gapCoefficient).roundToDouble();
    // Maximum possible gap.
    final maxGap = (minGap * _maxGapCoefficient).roundToDouble();
    // Use the custom random extension to get a value between min and max gap.
    return random.fromRange(minGap, maxGap);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move the obstacle to the left based on the current game speed.
    x -= gameRef.currentSpeed * dt;

    // If the obstacle is out of the screen, remove it from the game.
    if (!isVisible) {
      removeFromParent();
    }
  }
}
