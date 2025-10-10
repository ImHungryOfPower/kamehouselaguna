import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class LivePage extends ConsumerStatefulWidget {
  const LivePage({super.key});

  @override
  ConsumerState<LivePage> createState() => _LivePageState();
}

class _LivePageState extends ConsumerState<LivePage> {
  @override
  Widget build(BuildContext context) {
    final notif = ref.watch(notificationsServiceProvider);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transmisiones en vivo',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Activa las notificaciones para enterarte en tiempo real cuando haya un en vivo o evento especial. '
            '(MVP con simulación; listo para enlazar proveedor real).',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Switch(
                value: notif.isSubscribed,
                onChanged: (v) async {
                  if (v) {
                    await notif.subscribe();
                  } else {
                    await notif.unsubscribe();
                  }
                  setState(() {});
                },
              ),
              const SizedBox(width: 8),
              Text(notif.isSubscribed ? 'Notificaciones activas' : 'Notificaciones desactivadas'),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: notif.isSubscribed ? () {} : null,
            icon: const Icon(Icons.notifications_active),
            label: const Text('Probar notificación (placeholder)'),
          ),
        ],
      ),
    );
  }
}
