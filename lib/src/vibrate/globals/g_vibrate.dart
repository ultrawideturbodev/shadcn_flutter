import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:shadcn_flutter/src/vibrate/services/vibrate_service.dart';

/// Indicates that a task or action has completed.
void gVibrateSuccess() => VibrateService.locate.vibrate(HapticsType.success);

/// Indicates that a task or action has produced a warning of some kind.
void gVibrateWarning() => VibrateService.locate.vibrate(HapticsType.warning);

/// Indicates that an error has occurred.
void gVibrateError() => VibrateService.locate.vibrate(HapticsType.error);

/// Indicates a collision between small or lightweight UI objects.
void gVibrateLight() => VibrateService.locate.vibrate(HapticsType.light);

/// Indicates a collision between medium-sized or medium-weight UI objects.
void gVibrateMedium() => VibrateService.locate.vibrate(HapticsType.medium);

/// Indicates a collision between large or heavyweight UI objects.
void gVibrateHeavy() => VibrateService.locate.vibrate(HapticsType.heavy);

/// Indicates a collision between hard or inflexible UI objects.
void gVibrateRigid() => VibrateService.locate.vibrate(HapticsType.rigid);

/// Indicates a collision between soft or flexible UI objects.
void gVibrateSoft() => VibrateService.locate.vibrate(HapticsType.soft);

/// Indicates that a UI element's values are changing.
void gVibrateSelection() => VibrateService.locate.vibrate(HapticsType.selection);
