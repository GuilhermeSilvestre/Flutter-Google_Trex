// GameOverPanel is a Flame Component which will display the game over UI elements.
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:trex_final_game/trex_game_manager.dart';

class GameOverPanel extends Component {
  // A flag indicating whether the game over panel should be visible or not.
  bool visible = false;

  @override
  Future<void> onLoad() async {
    // Adding the Game Over text and restart button to the game over panel.
    add(GameOverText());
    add(GameOverRestart());
  }

  @override
  void renderTree(Canvas canvas) {
    // Render the children components (text and restart button) only if the panel is set to visible.
    if (visible) {
      super.renderTree(canvas);
    }
  }
}

// Component to render the "Game Over" text.
class GameOverText extends SpriteComponent with HasGameRef<TRexGameManager> {
  // Default constructor initializing the size and anchor of the sprite.
  GameOverText() : super(size: Vector2(382, 25), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Loading the sprite image for the Game Over text.
    sprite = Sprite(
      gameRef.spriteImage,
      srcPosition: Vector2(955.0, 26.0),
      srcSize: size,
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // Centering the Game Over text horizontally and positioning it at the 1/4th height of the screen.
    x = size.x / 2;
    y = size.y * .25;
  }
}

// Component to render the restart button.
class GameOverRestart extends SpriteComponent with HasGameRef<TRexGameManager> {
  // Default constructor initializing the size and anchor of the sprite.
  GameOverRestart() : super(size: Vector2(72, 64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Loading the sprite image for the restart button.
    sprite = Sprite(
      gameRef.spriteImage,
      srcPosition: Vector2.all(2.0),
      srcSize: size,
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // Centering the restart button horizontally and positioning it at the 3/4th height of the screen.
    x = size.x / 2;
    y = size.y * .75;
  }
}
