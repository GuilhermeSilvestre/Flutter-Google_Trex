// Importing required libraries and packages.
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart'
    hide Image; // Avoiding naming conflicts with Flame's Image.
import 'package:flutter/services.dart';
import 'package:trex_final_game/player.dart';

import 'background/horizon_manager.dart';
import 'game_over_manager.dart';

// Defining game states for the T-Rex game.
enum GameState { playing, intro, gameOver }

// The main game class.
class TRexGameManager extends FlameGame
    with KeyboardEvents, TapDetector, HasCollisionDetection {
  static const String description = '''
    A game similar to the game in chrome that you get to play while offline.
    Press space or tap/click the screen to jump, the more obstacles you manage
    to survive, the more points you get.
  ''';

  late final Image spriteImage; // Sprite image for the T-Rex.

  // Default background color for the game.
  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  // Game components.
  late final player = Player();
  late final horizon = HorizonManager();
  late final gameOverPanel = GameOverPanel();
  late final TextComponent scoreText;

  int _score = 0;
  int _highscore = 0;

  // Getter and setter for the score to manage the displayed score text.
  int get score => _score;
  set score(int newScore) {
    _score = newScore;
    scoreText.text = '${scoreString(_score)}  HI ${scoreString(_highscore)}';
  }

  // Format the score with leading zeros.
  String scoreString(int score) => score.toString().padLeft(5, '0');

  double _distanceTraveled = 0; // Used for score calculation.

  @override
  Future<void> onLoad() async {
    // Load the sprite image.
    spriteImage = await Flame.images.load('trex.png');
    // Add the main game components to the scene.
    add(player);
    add(horizon);
    add(gameOverPanel);

    // Setup for rendering the score text using a SpriteFont.
    const chars = '0123456789HI ';
    final renderer = SpriteFontRenderer.fromFont(
      SpriteFont(
        source: spriteImage,
        size: 23,
        ascent: 23,
        glyphs: [
          for (var i = 0; i < chars.length; i++)
            Glyph(chars[i], left: 954.0 + 20 * i, top: 0, width: 20)
        ],
      ),
      letterSpacing: 2,
    );
    // Adding the score text to the game scene.
    add(
      scoreText = TextComponent(
        position: Vector2(20, 20),
        textRenderer: renderer,
      ),
    );
    score = 0;
  }

  // Variables to manage the game state and game logic.
  GameState state = GameState.intro;
  double currentSpeed = 0.0;
  double timePlaying = 0.0;

  // Constants for controlling game speed.
  final double acceleration = 10;
  final double maxSpeed = 2500.0;
  final double startSpeed = 600;

  // Various getters to check the current state.
  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;

  // Handling keyboard events.
  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (keysPressed.contains(LogicalKeyboardKey.enter) ||
        keysPressed.contains(LogicalKeyboardKey.space)) {
      onAction();
    }
    return KeyEventResult.handled;
  }

  // Handling tap events.
  @override
  void onTapDown(TapDownInfo info) {
    onAction();
  }

  // Logic for when a user action (tap/press) occurs.
  void onAction() {
    if (isGameOver || isIntro) {
      restart();
      return;
    }
    player.jump();
  }

  // Logic for the game over state.
  void gameOver() {
    gameOverPanel.visible = true;
    state = GameState.gameOver;
    player.current = PlayerState.crashed;
    currentSpeed = 0.0;
  }

  // Logic to restart the game.
  void restart() {
    state = GameState.playing;
    player.reset();
    horizon.reset();
    currentSpeed = startSpeed;
    gameOverPanel.visible = false;
    if (score > _highscore) {
      _highscore = score;
    }
    score = 0;
    _distanceTraveled = 0;

    timePlaying = 0.0;
  }

  // Update loop for the game.
  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) {
      return;
    }

    if (isPlaying) {
      timePlaying += dt;
      _distanceTraveled += dt * currentSpeed;
      score = _distanceTraveled ~/ 50;

      // Increase the game speed up to a max limit.
      if (currentSpeed < maxSpeed) {
        currentSpeed += acceleration * dt;
      }
    }
  }
}
