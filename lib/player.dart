// Importing the required packages for game and component functionalities.
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:trex_final_game/trex_game_manager.dart';

// Enumeration of different states the Player can be in.
enum PlayerState { crashed, jumping, running, waiting }

// The Player class extends SpriteAnimationGroupComponent for handling sprite-based animations and transitions
// between various player states. It also implements collision detection functionality.
class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<TRexGameManager>, CollisionCallbacks {
  // Default constructor initializing the size of the player sprite.
  Player() : super(size: Vector2(90, 88));

  @override
  bool debugMode = false;

  // Constants defining the player's physics and position.
  final double gravity = 1;
  final double initialJumpVelocity = -15.0;
  final double introDuration = 1500.0;
  final double startXPosition = 50;
  double _jumpVelocity = 0.0;

  // Computed property to get the player's Y position on the ground.
  double get groundYPos {
    return (gameRef.size.y / 2) - height / 2;
  }

  @override
  Future<void> onLoad() async {
    // Define hitboxes for body and head for collision detection.
    add(RectangleHitbox.relative(Vector2(1.0, 1.0),
        position: Vector2(0, 0), parentSize: size));

    // Define various sprite animations for the different player states.
    animations = {
      PlayerState.running: _getAnimation(
        size: Vector2(88.0, 90.0),
        frames: [Vector2(1514.0, 4.0), Vector2(1602.0, 4.0)],
        stepTime: 0.2,
      ),
      PlayerState.waiting: _getAnimation(
        size: Vector2(88.0, 90.0),
        frames: [Vector2(76.0, 6.0)],
      ),
      PlayerState.jumping: _getAnimation(
        size: Vector2(88.0, 90.0),
        frames: [Vector2(1339.0, 6.0)],
      ),
      PlayerState.crashed: _getAnimation(
        size: Vector2(88.0, 90.0),
        frames: [Vector2(1782.0, 6.0)],
      ),
    };
    // set starting dino state
    current = PlayerState.waiting;
  }

  // Method to initiate player jump.
  void jump() {
    if (current == PlayerState.jumping) {
      return;
    }
    current = PlayerState.jumping;
    _jumpVelocity = initialJumpVelocity;
  }

  // Reset player's state to running after jump or crash.
  void reset() {
    y = groundYPos;
    _jumpVelocity = 0.0;
    current = PlayerState.running;
  }

  // Update method is called every frame to update the player's position and state.
  @override
  void update(double dt) {
    super.update(dt);
    // Logic to handle player jump and reset its position after landing.
    if (current == PlayerState.jumping) {
      y += _jumpVelocity;
      _jumpVelocity += gravity;
      if (y > groundYPos) {
        reset();
      }
    } else {
      y = groundYPos;
    }
    // Logic to move the player to the starting X position during the game's intro phase.
    if (gameRef.isIntro && x < startXPosition) {
      x += (startXPosition / introDuration) * dt * 5000;
    }
  }

  // Event when the game's viewport is resized.
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    y = groundYPos;
  }

  // Event when the player collides with another entity in the game.
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    gameRef.gameOver();
  }

  // Helper method to generate sprite animations from a list of frames.
  SpriteAnimation _getAnimation({
    required Vector2 size,
    required List<Vector2> frames,
    double stepTime = double.infinity,
  }) {
    return SpriteAnimation.spriteList(
      frames
          .map(
            (vector) => Sprite(
              gameRef.spriteImage,
              srcSize: size,
              srcPosition: vector,
            ),
          )
          .toList(),
      stepTime: stepTime,
    );
  }
}
