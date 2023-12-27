import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';

import '../obstacle/obstacle_manager.dart';
import '../trex_game_manager.dart';
import 'cloud_manager.dart';

///
/// Class HorizonManager represents the ground/horizon in the game. It continuously
/// loops the ground to give the illusion of the T-Rex running.
///
/// The class also integrates cloud and obstacle managers for their respective
/// appearances on the horizon. <TODO>
///
/// The ground itself has two types of visuals: soft and bumpy.
/// The logic ensures that they appear in alternating patterns.
///
/// Eventually we can randomize the Horizon Line to make the ground patterns
/// more unpredicable.
///

class HorizonManager extends PositionComponent
    with HasGameRef<TRexGameManager> {
  HorizonManager() : super();

  // Define the size of each horizon line (ground layer).
  // we will 'cut out' this exact size from the Assets PNG (trex.png)
  static final Vector2 lineSize = Vector2(1200, 24);

  // Queue to hold all ground layers.
  // This queue is simply cycled so that as a layer moves out of view on the
  // left side iot is added to the back of the queue it will then re-appear
  // again after a few iterations.
  final Queue<SpriteComponent> groundLayers = Queue();

  // Managers for the cloud and obstacles
  late final CloudManager cloudManager = CloudManager();
  late final ObstacleManager obstacleManager = ObstacleManager();

  // Define two types of ground sprites: soft and bumpy.
  //
  //

  // this is the first half of the ground line from the
  // Assets PNG (i.e. trex.png)
  // We are loading it from the (2.0, 104.0) x-y position
  late final _softSprite = Sprite(
    gameRef.spriteImage,
    srcPosition: Vector2(2.0, 104.0),
    srcSize: lineSize,
  );

  // this is the second half of the ground line from the
  // Assets PNG (i.e. trex.png)
  // We are loading it from the 2nd half of the PNG
  late final _bumpySprite = Sprite(
    gameRef.spriteImage,
    srcPosition: Vector2(gameRef.spriteImage.width / 2, 104.0),
    srcSize: lineSize,
  );

  @override
  Future<void> onLoad() async {
    // Load cloud and obstacle managers.
    add(cloudManager);
    add(obstacleManager);
  }

  // This is called every frame to update the component.
  @override
  void update(double dt) {
    super.update(dt);

    // Calculate the distance to move each ground layer in this frame.
    final increment = gameRef.currentSpeed * dt;

    // Move each ground layer to the left.
    for (final line in groundLayers) {
      line.x -= increment;
    }

    // Check if the first ground layer has moved out of view.
    // If so, move it to the end of the queue to create a looping effect.
    final firstLine = groundLayers.first;
    if (firstLine.x <= -firstLine.width) {
      firstLine.x = groundLayers.last.x + groundLayers.last.width;
      groundLayers.remove(firstLine);
      groundLayers.add(firstLine);
    }
  }

  // This is called when the game is resized.
  // which always happend at the beginning as well so we are guaranteed that
  // this will be called at least once at the start of the game.
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    // Create new ground layers based on the game size.
    final newLines = _generateLines();
    groundLayers.addAll(newLines);
    addAll(newLines);

    // Update the vertical position of the horizon.
    y = (size.y / 2) + 21.0;
  }

  // Reset the horizon and other managers.
  void reset() {
    // Reset both cloud and obstacle managers.
    cloudManager.reset();
    obstacleManager.reset();

    // Reset position of each ground layer.
    groundLayers.forEachIndexed((i, line) => line.x = i * lineSize.x);
  }

  // Helper function to generate the required number of ground layers.
  //
  List<SpriteComponent> _generateLines() {
    // Calculate the number of lines needed based on the game width.
    final number =
        1 + (gameRef.size.x / lineSize.x).ceil() - groundLayers.length;

    // Get the x-coordinate of the last ground layer.
    final lastX = (groundLayers.lastOrNull?.x ?? 0) +
        (groundLayers.lastOrNull?.width ?? 0);

    // Generate and return a list of SpriteComponents for the ground layers.
    return List.generate(
      max(number, 0),
      (i) => SpriteComponent(
        sprite: (i + groundLayers.length).isEven ? _softSprite : _bumpySprite,
        size: lineSize,
      )..x = lastX + lineSize.x * i,
      growable: false,
    );
  }
}
