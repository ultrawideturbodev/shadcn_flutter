import 'package:flutter/foundation.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

/// A service that provides haptic feedback functionality.
///
/// Uses the [Haptics] package to check device vibration capabilities and trigger
/// haptic feedback. Follows a singleton pattern with lazy initialization.
class VibrateService {
  /// Private constructor that initializes the service.
  VibrateService._() {
    initialise();
  }

  static VibrateService? _instance;

  /// Gets the singleton instance of [VibrateService], creating it if needed.
  static VibrateService get locate => _instance ??= VibrateService._();

  /// Whether the device supports haptic feedback.
  bool? _canVibrate;

  /// Initializes the vibration service by checking device capabilities.
  ///
  /// Sets [_canVibrate] based on whether the device supports haptic feedback.
  /// Always returns false on web platforms.
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

  /// Triggers a haptic feedback of the specified [type].
  ///
  /// Does nothing if the device doesn't support haptic feedback.
  /// ```dart
  /// // Trigger a light impact vibration
  /// await vibrateService.vibrate(HapticsType.lightImpact);
  /// ```
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
