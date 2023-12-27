// Importing required Dart core library to utilize mathematical functions and classes.
import 'dart:math';

// Global instance of the Random class, useful for generating random numbers.
Random random = Random();

// Extension on the built-in Random class to provide additional utility.
extension RandomExtension on Random {
  // Generates a random double between a given range [min, max].
  double fromRange(double min, double max) =>
      // The main logic multiplies the nextDouble (which returns a double between 0 and 1)
      // by the range, then floors it and shifts it by the minimum value.
      (nextDouble() * (max - min + 1)).floor() + min;
}
