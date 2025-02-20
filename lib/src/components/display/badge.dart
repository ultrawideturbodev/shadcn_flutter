import 'package:shadcn_flutter/shadcn_flutter.dart';

class PrimaryBadge extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final AbstractButtonStyle? style;

  const PrimaryBadge({
    super.key,
    required this.child,
    this.onPressed,
    this.leading,
    this.trailing,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      child: Button(
        leading: leading,
        trailing: trailing,
        onPressed: onPressed,
        enabled: true,
        style: style ??
            const ButtonStyle.primary(
              buttonSize: ButtonSize.small,
              density: ButtonDensity.dense,
              shape: ButtonShape.rectangle,
            ).copyWith(
              textStyle: (context, states, value) {
                return value.copyWith(
                  fontWeight: FontWeight.w500,
                );
              },
            ),
        child: child,
      ),
    );
  }
}

class SecondaryBadge extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final AbstractButtonStyle? style;

  const SecondaryBadge({
    super.key,
    required this.child,
    this.onPressed,
    this.leading,
    this.trailing,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      child: Button(
        leading: leading,
        trailing: trailing,
        onPressed: onPressed,
        enabled: true,
        style: style ??
            const ButtonStyle.secondary(
              buttonSize:ButtonSize.small,
              density: ButtonDensity.dense,
              shape: ButtonShape.rectangle,
            ).copyWith(
              textStyle: (context, states, value) {
                return value.copyWith(
                  fontWeight: FontWeight.w500,
                );
              },
            ),
        child: child,
      ),
    );
  }
}

class OutlineBadge extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final AbstractButtonStyle? style;

  const OutlineBadge({
    super.key,
    required this.child,
    this.onPressed,
    this.leading,
    this.trailing,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      child: Button(
        leading: leading,
        trailing: trailing,
        onPressed: onPressed,
        enabled: true,
        style: style ??
            const ButtonStyle.outline(
              buttonSize:ButtonSize.small,
              density: ButtonDensity.dense,
              shape: ButtonShape.rectangle,
            ).copyWith(
              textStyle: (context, states, value) {
                return value.copyWith(
                  fontWeight: FontWeight.w500,
                );
              },
            ),
        child: child,
      ),
    );
  }
}

class DestructiveBadge extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final AbstractButtonStyle? style;

  const DestructiveBadge({
    super.key,
    required this.child,
    this.onPressed,
    this.leading,
    this.trailing,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      child: Button(
        leading: leading,
        trailing: trailing,
        onPressed: onPressed,
        enabled: true,
        style: style ??
            const ButtonStyle.destructive(
              buttonSize:ButtonSize.small,
              density: ButtonDensity.dense,
              shape: ButtonShape.rectangle,
            ).copyWith(
              textStyle: (context, states, value) {
                return value.copyWith(
                  fontWeight: FontWeight.w500,
                );
              },
            ),
        child: child,
      ),
    );
  }
}
