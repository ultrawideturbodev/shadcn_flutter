import 'package:flutter/widgets.dart';

class IconBox extends StatelessWidget {
  const IconBox({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 32,
        width: 32,
        child: child,
      );
}
