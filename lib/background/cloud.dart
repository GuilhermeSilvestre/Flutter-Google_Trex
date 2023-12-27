import 'package:flame/components.dart';
import 'package:trex_final_game/background/cloud_manager.dart';
import '../trex_game_manager.dart';
import '../utils/random_extension.dart';

///
/// The Cloud class represents individual clouds in the game.
///
/// The clouds move from the right to the left of the screen at a speed
/// determined by the cloudSpeed in the CloudManager (which is the parent
/// component of this Cloud class).
///
/// Each cloud has a random gap between them which is determined when they
/// are created, ensuring that clouds are spread out across the screen.
/// Once a cloud is no longer visible (moved completely to the left off-screen),
/// it's removed from the game.
/// The vertical position of clouds also has some variation to simulate
/// randomness in their appearance.
///

class Cloud extends SpriteComponent
    with ParentIsA<CloudManager>, HasGameRef<TRexGameManager> {
  // Constructor for the Cloud class. The position is required when creating a cloud.
  // It also sets the cloudGap, which is the distance between clouds.
  Cloud({required Vector2 position})
      : cloudGap = random.fromRange(
          minCloudGap,
          maxCloudGap,
        ),
        super(
          position: position,
          size: initialSize,
        );

  // Cloud initial size.
  static Vector2 initialSize = Vector2(92.0, 28.0);

  // Constants defining the maximum and minimum gap between clouds.
  static const double maxCloudGap = 400.0;
  static const double minCloudGap = 100.0;

  // Constants for the maximum and minimum vertical position of the clouds.
  static const double maxSkyLevel = 71.0;
  static const double minSkyLevel = 30.0;

  // The gap between this cloud and the next one.
  final double cloudGap;

  @override
  Future<void> onLoad() async {
    // Set the sprite image for the cloud. This defines how the cloud looks.
    sprite = Sprite(
      gameRef.spriteImage,
      srcPosition: Vector2(166.0, 2.0),
      srcSize: initialSize,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // If the cloud is set to be removed, it doesn't update its position.
    if (isRemoving) {
      return;
    }
    // Move the cloud to the left based on the speed of the cloudManager's cloudSpeed.
    x -= parent.cloudSpeed.ceil() * 50 * dt;

    // If the cloud is no longer visible on screen, remove it from the parent.
    if (!isVisible) {
      removeFromParent();
    }
  }

  // Property to check if the cloud is still visible on the screen.
  bool get isVisible {
    return x + width > 0;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // Adjust the vertical position of the cloud based on game size.
    // It adds randomness between minSkyLevel and maxSkyLevel for variation.
    y = ((absolutePosition.y / 2 - (maxSkyLevel - minSkyLevel)) +
            random.fromRange(minSkyLevel, maxSkyLevel)) -
        absolutePositionOf(absoluteTopLeftPosition).y;
  }
}
