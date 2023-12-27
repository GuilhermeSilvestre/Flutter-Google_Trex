import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';
import 'package:trex_final_game/trex_widget.dart';

void main() {
  /// what platform are we running on?
  const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

  /// if not web then assume for now that it is a mobile device
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    Flame.device.fullScreen();
    Flame.device.setLandscape();
  }
  runApp(
    const TRexWidget(),
  );
}
