import 'package:flame/components.dart';
import 'package:trex_final_game/background/cloud.dart';
import 'package:trex_final_game/utils/random_extension.dart';
import '../trex_game_manager.dart';

///
/// The CloudManager class manages the generation and removal of cloud objects
/// in the game.
/// It ensures that clouds are created and displayed at appropriate intervals
/// based on the game's speed, the frequency of cloud generation, and the
/// maximum number of clouds allowed on the screen.
///
/// When the game needs to be reset, it offers a method to remove
/// all cloud objects.
///

class CloudManager extends PositionComponent with HasGameRef<TRexGameManager> {
  // Defining constants for the cloud manager.
  final double cloudFrequency = 0.5; // Frequency of cloud generation.
  final int maxClouds =
      20; // Maximum number of clouds that can be on screen at a time.
  final double bgCloudSpeed = 0.2; // Base cloud speed.

  // Method to add a cloud to the game.
  void addCloud() {
    // Determine the position where the new cloud will be added.
    // The cloud starts off the screen to the right and will move leftward.
    final cloudPosition = Vector2(
      gameRef.size.x + Cloud.initialSize.x + 10,
      ((absolutePosition.y / 2 - (Cloud.maxSkyLevel - Cloud.minSkyLevel)) +
              random.fromRange(Cloud.minSkyLevel, Cloud.maxSkyLevel)) -
          absolutePosition.y,
    );
    // Create the cloud with the determined position and add it to the game.
    add(Cloud(position: cloudPosition));
  }

  // Getter to calculate the cloud's speed based on the current speed of the game.
  double get cloudSpeed => bgCloudSpeed / 1000 * gameRef.currentSpeed;

  @override
  void update(double dt) {
    super.update(dt);
    // Get the number of clouds currently in the game.
    final numClouds = children.length;
    if (numClouds > 0) {
      // If there are already clouds, get the last cloud added.
      final lastCloud = children.last as Cloud;
      // If the number of clouds is less than the maximum limit and
      // there's enough gap to the last cloud, then add a new cloud.
      if (numClouds < maxClouds &&
          (gameRef.size.x / 2 - lastCloud.x) > lastCloud.cloudGap) {
        addCloud();
      }
    } else {
      // If there are no clouds, add one.
      addCloud();
    }
  }

  // Method to remove all clouds from the game. Usually called during reset scenarios.
  void reset() {
    removeAll(children);
  }
}
