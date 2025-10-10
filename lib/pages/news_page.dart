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
    final dateStr = DateFormat('dd/MM/yyyy – HH:mm').format(item.date.toLocal());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: item.image.isEmpty
                      ? Image.asset('assets/logo.png', width: 72, height: 72, fit: BoxFit.cover)
                      : Image.network(item.image, width: 72, height: 72, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(item.summary, maxLines: 3, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: -8,
              children: [
                ...item.tags.map((t) => Chip(label: Text('#$t'))),
                Chip(label: Text(dateStr)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
