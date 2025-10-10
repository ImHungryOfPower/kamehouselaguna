import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class MessagesPage extends ConsumerStatefulWidget {
  const MessagesPage({super.key});

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  String? current;

  void _next() {
    final svc = ref.read(randomMessageServiceProvider);
    setState(() => current = svc.next());
  }

  @override
  void initState() {
    super.initState();
    _next();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  current ?? '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _next,
              icon: const Icon(Icons.shuffle),
              label: const Text('Nuevo mensaje'),
            )
          ],
        ),
      ),
    );
  }
}
