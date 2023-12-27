// Importing necessary libraries and packages.
import 'package:flame/game.dart';
// Importing all widgets from Flutter's material.dart except for Image and Gradient
// to avoid name conflicts as Flame also uses these names.
import 'package:flutter/material.dart' hide Image, Gradient;
// Importing our custom game logic for the T-Rex game.
import 'package:trex_final_game/trex_game_manager.dart';

// A stateless widget for displaying the T-Rex game.
class TRexWidget extends StatelessWidget {
  // Constructor for TRexWidget.
  // Using the 'super.key' allows us to pass the key property to the parent class.
  const TRexWidget({super.key});

  // Build method that describes the widget in terms of other, lower-level widgets.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Setting the application title.
      title: 'T-Rex',
      // The main app UI structure.
      home: Container(
        // Background color for the game container.
        color: Colors.black,
        // Margins to ensure the game doesn't take up the full screen.
        margin: const EdgeInsets.all(45),
        child: ClipRect(
          // Embedding the game inside a GameWidget, which comes from the Flame package.
          child: GameWidget(
            // Initiating an instance of the T-Rex game.
            game: TRexGameManager(),
            // Display a loading text while the game assets are being loaded.
            loadingBuilder: (_) => const Center(
              child: Text('Loading'),
            ),
          ),
        ),
      ),
    );
  }
}
