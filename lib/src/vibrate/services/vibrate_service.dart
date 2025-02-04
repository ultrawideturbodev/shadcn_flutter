import 'package:flutter/foundation.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class VibrateService {
  VibrateService._() {
    initialise();
  }

  static VibrateService? _instance;

  // 📍 LOCATOR ------------------------------------------------------------------------------- \\

  static VibrateService get locate => _instance ??= VibrateService._();

  // 🧩 DEPENDENCIES -------------------------------------------------------------------------- \\
  // 🎬 INIT & DISPOSE ------------------------------------------------------------------------ \\

  Future<void> initialise() async {
    try {
      _canVibrate = !kIsWeb && await Haptics.canVibrate();
    } catch (error, _) {
      if (kDebugMode) {
        print('$error caught while trying to initialise the VibrateService.');
      }
      _canVibrate = false;
    }
  }

  // 🎩 STATE --------------------------------------------------------------------------------- \\

  bool? _canVibrate;

  // 🛠 UTIL ---------------------------------------------------------------------------------- \\
  // 🧲 FETCHERS ------------------------------------------------------------------------------ \\
  // 🏗️ HELPERS ------------------------------------------------------------------------------- \\
  // 🪄 MUTATORS ------------------------------------------------------------------------------ \\

  Future<void> vibrate(HapticsType type) async {
    try {
      if (_canVibrate == false) return;
      await Haptics.vibrate(type);
    } catch (error, _) {
      if (kDebugMode) {
        print('$error caught while trying to vibrate.');
      }
    }
  }
}
