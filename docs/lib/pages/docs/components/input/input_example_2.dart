import 'package:shadcn_flutter/shadcn_flutter.dart';

class InputExample2 extends StatefulWidget {
  const InputExample2({super.key});

  @override
  State<InputExample2> createState() => _InputExample2State();
}

class _InputExample2State extends State<InputExample2> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      initialValue: 'Hello World!',
      placeholder: const Text('Search something...'),
      leading: StatedWidget.builder(
        builder: (context, states) {
          if (states.focused) {
            return const Icon(Icons.search);
          } else {
            return const Icon(Icons.search).iconMutedForeground();
          }
        },
      ),
      trailing: IconButton.text(
        icon: const Icon(Icons.close),
        density: ButtonDensity.compact,
        onPressed: () {
          _searchController.clear();
        },
      ),
    );
  }
}
