import 'dart:math';

import 'package:flutter/material.dart' as material;
import 'package:shadcn_flutter/shadcn_flutter.dart';

extension ColorExtension on Color {
  /// Returns a high-contrast foreground color suitable for text and UI elements
  /// based on this background color.
  Color get shadForeground {
    final HSLColor hsl = HSLColor.fromColor(this);
    final bool isLight =
        material.ThemeData.estimateBrightnessForColor(this) == material.Brightness.light;

    if (isLight) {
      // For light backgrounds, start with black and add a hint of the background's hue
      return HSLColor.fromAHSL(
        1.0,
        hsl.hue,
        min(0.4, hsl.saturation * 0.5), // Keep saturation low for better contrast
        0.1, // Start very dark (near black)
      ).toColor();
    } else {
      // For dark backgrounds, start with white and add a hint of the background's hue
      return HSLColor.fromAHSL(
        1.0,
        hsl.hue,
        min(0.2, hsl.saturation * 0.3), // Keep saturation very low for better contrast
        0.95, // Start very light (near white)
      ).toColor();
    }
  }

  /// Lightens the color with the given integer percentage amount.
  /// Defaults to 5%.
  Color lighten([final int amount = 5]) {
    if (amount <= 0) return this;
    if (amount > 100) return Colors.white;
    // HSLColor returns saturation 1 for black, we want 0 instead to be able
    // lighten black color up along the grey scale from black.
    final HSLColor hsl = this == const Color(0xFF000000)
        ? HSLColor.fromColor(this).withSaturation(0)
        : HSLColor.fromColor(this);
    final Color color = hsl.withLightness(min(1, max(0, hsl.lightness + amount / 100))).toColor();
    return color;
  }

  /// Darkens the color with the given integer percentage amount.
  /// Defaults to 5%.
  Color darken([final int amount = 5]) {
    if (amount <= 0) return this;
    if (amount > 100) return Colors.black;
    final HSLColor hsl = HSLColor.fromColor(this);
    final Color color = hsl.withLightness(min(1, max(0, hsl.lightness - amount / 100))).toColor();
    return color;
  }

  Color get shadHovered {
    if (this == const Color(0xFF2D1A4A)) {
      return const Color(0xFF3C295A);
    }
    if (this == const Color(0xFFFFFFFF)) {
      return darken((3));
    }

    final HSLColor hsl = HSLColor.fromColor(this);
    final bool isLight =
        material.ThemeData.estimateBrightnessForColor(this) == material.Brightness.light;

    if (isLight) {
      return darken(4);
      // final double newLightness = max(0, hsl.lightness - 0.05);
      // final double newSaturation = min(1, hsl.saturation + 0.01);
      // return hsl.withLightness(newLightness).withSaturation(newSaturation).toColor();
    } else {
      return lighten(4);
      // final double newLightness = min(1, hsl.lightness + 0.03);
      // final double newSaturation = min(1, hsl.saturation - 0.04);
      // return hsl.withLightness(newLightness).withSaturation(newSaturation).toColor();
    }
  }
}
