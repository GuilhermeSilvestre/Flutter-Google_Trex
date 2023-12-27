import 'dart:collection';

import 'package:flame/components.dart';
import 'package:trex_final_game/obstacle/obstacle.dart';
import 'package:trex_final_game/obstacle/obstacle_type.dart';
import 'package:trex_final_game/utils/random_extension.dart';

import '../trex_game_manager.dart';

///
/// Class ObstacleManager is responsible for managing the generation and
/// placement of obstacles in the game.
///
/// It ensures that obstacles are generated and placed at appropriate
/// intervals based on game speed and also checks to avoid too many
/// consecutive duplications of the same obstacle type.
///

class ObstacleManager extends Component with HasGameRef<TRexGameManager> {
  ObstacleManager();

  // Maintaining a queue to track the history of obstacles.
  ListQueue<ObstacleType> history = ListQueue();
  static const int maxObstacleDuplication =
      2; // Maximum times an obstacle can be duplicated consecutively.

  @override
  void update(double dt) {
    // Retrieve all the obstacles present.
    final obstacles = children.query<Obstacle>();

    if (obstacles.isNotEmpty) {
      // Get the last obstacle added.
      final lastObstacle = children.last as Obstacle?;

      // If the last obstacle is nearing its end and the following one hasn't been created yet, then create it.
      if (lastObstacle != null &&
          !lastObstacle.followingObstacleCreated &&
          lastObstacle.isVisible &&
          (lastObstacle.x + lastObstacle.width + lastObstacle.gap) <
              gameRef.size.x) {
        addNewObstacle();
        lastObstacle.followingObstacleCreated = true;
      }
    } else {
      // If no obstacles are present, add a new one.
      addNewObstacle();
    }
  }

  void addNewObstacle() {
    final speed = gameRef.currentSpeed;

    // If game speed is 0, don't add obstacles.
    if (speed == 0) {
      return;
    }

    // Randomly choose between small and large cactus as the next obstacle.
    var settings = random.nextBool()
        ? ObstacleTypeSettings.cactusSmall
        : ObstacleTypeSettings.cactusLarge;

    // If the chosen obstacle is not suitable due to repeated occurrence or speed constraints, default to small cactus.
    if (duplicateObstacleCheck(settings.type) || speed < settings.allowedAt) {
      settings = ObstacleTypeSettings.cactusSmall;
    }

    // Determine the group size of obstacles and add them.
    final groupSize = _groupSize(settings);
    for (var i = 0; i < groupSize; i++) {
      add(Obstacle(settings: settings, groupIndex: i));
      gameRef.score++; // Increment the game score.
    }

    // Add the obstacle type to history.
    history.addFirst(settings.type);

    // If history exceeds the max allowed duplicate count, remove the last (oldest) entry.
    while (history.length > maxObstacleDuplication) {
      history.removeLast();
    }
  }

  // Checks if the next obstacle type has been duplicated consecutively more than allowed.
  bool duplicateObstacleCheck(ObstacleType nextType) {
    var duplicateCount = 0;

    for (final type in history) {
      duplicateCount += type == nextType ? 1 : 0;
    }
    return duplicateCount >= maxObstacleDuplication;
  }

  // Reset the manager by removing all children obstacles and clearing the history.
  void reset() {
    removeAll(children);
    history.clear();
  }

  // Determine the number of obstacles that should appear together in a group.
  int _groupSize(ObstacleTypeSettings settings) {
    if (gameRef.currentSpeed > settings.multipleAt) {
      return random.fromRange(1.0, ObstacleTypeSettings.maxGroupSize).floor();
    } else {
      return 1;
    }
  }
}
