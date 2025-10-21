import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers.dart';
import '../models/news_item.dart';

class NewsPage extends ConsumerWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNews = ref.watch(newsProvider);

    return asyncNews.when(
      data: (items) => RefreshIndicator(
        onRefresh: () async {
          // invalida para recargar
          ref.invalidate(newsProvider);
        },
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) => _NewsCard(item: items[i]),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error al cargar noticias\n$e')),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsItem item;
  const _NewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final accent = _accentColorForItem(context, item);
    final isRecent = DateTime.now().difference(item.date).inHours < 24;
    final relative = _timeAgoEs(item.date);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: accent, width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emoji badge
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [_badgeStartForItem(item), accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _emojiForItem(item),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        relative,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey[600]),
                      ),
                      if (isRecent) ...[
                        const SizedBox(width: 4),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.summary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton(
                    onPressed: () {},
                    child: Text(_primaryCtaForItem(item)),
                  ),
                  FilledButton.tonal(
                    onPressed: () {},
                    child: Text(_secondaryCtaForItem(item)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helpers for look & feel similar to the mock
String _timeAgoEs(DateTime date) {
  final now = DateTime.now();
  final local = date.toLocal();
  final diff = now.difference(local);
  if (diff.inMinutes < 1) return 'Ahora';
  if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'Hoy';
  if (diff.inDays == 1) return 'Hace 1 día';
  if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
  return DateFormat('dd/MM/yyyy').format(local);
}

String _emojiForItem(NewsItem item) {
  final lowerTags = item.tags.map((e) => e.toLowerCase()).toList();
  if (lowerTags.any((t) => t.contains('descuento') || t.contains('oferta'))) return '🔥';
  if (lowerTags.any((t) => t.contains('en-vivo') || t.contains('vivo'))) return '🔴';
  if (lowerTags.any((t) => t.contains('evento') || t.contains('llegará'))) return '🎉';
  if (lowerTags.any((t) => t.contains('comunicado'))) return '📣';
  if (item.title.toLowerCase().contains('figura')) return '🆕';
  return '🆕';
}

Color _accentColorForItem(BuildContext context, NewsItem item) {
  final scheme = Theme.of(context).colorScheme;
  final lowerTags = item.tags.map((e) => e.toLowerCase()).toList();
  if (lowerTags.any((t) => t.contains('descuento') || t.contains('oferta'))) return Colors.deepOrange;
  if (lowerTags.any((t) => t.contains('en-vivo') || t.contains('vivo'))) return Colors.redAccent;
  if (lowerTags.any((t) => t.contains('evento'))) return scheme.primary;
  return scheme.secondary;
}

Color _badgeStartForItem(NewsItem item) {
  final lowerTags = item.tags.map((e) => e.toLowerCase()).toList();
  if (lowerTags.any((t) => t.contains('descuento') || t.contains('oferta'))) return const Color(0xFFFFB74D);
  if (lowerTags.any((t) => t.contains('en-vivo') || t.contains('vivo'))) return const Color(0xFFFF8A80);
  if (lowerTags.any((t) => t.contains('evento'))) return const Color(0xFF93C5FD);
  return const Color(0xFFFDE68A);
}

String _primaryCtaForItem(NewsItem item) {
  final lowerTags = item.tags.map((e) => e.toLowerCase()).toList();
  if (lowerTags.any((t) => t.contains('descuento') || t.contains('oferta'))) return 'Comprar';
  if (lowerTags.any((t) => t.contains('evento'))) return 'Reservar';
  if (lowerTags.any((t) => t.contains('en-vivo') || t.contains('vivo'))) return 'Ver en vivo';
  return 'Ver Producto';
}

String _secondaryCtaForItem(NewsItem item) {
  final lowerTags = item.tags.map((e) => e.toLowerCase()).toList();
  if (lowerTags.any((t) => t.contains('evento'))) return 'Recordar';
  return 'Más tarde';
}
