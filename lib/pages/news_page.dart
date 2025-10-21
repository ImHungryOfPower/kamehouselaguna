import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers.dart';
import '../models/news_item.dart';

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncNews = ref.watch(newsProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8F9FA), Color(0xFFFFFFFF)],
        ),
      ),
      child: asyncNews.when(
        data: (items) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(newsProvider);
            await Future.delayed(const Duration(milliseconds: 300));
          },
          color: const Color(0xFFFF6B35),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final animation = CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  i * 0.1 > 1 ? 1 : i * 0.1,
                  (i * 0.1 + 0.5) > 1 ? 1 : i * 0.1 + 0.5,
                  curve: Curves.easeOutCubic,
                ),
              );
              return _NewsCard(item: items[i], animation: animation);
            },
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
          ),
        ),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error al cargar noticias\n$e', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatefulWidget {
  final NewsItem item;
  final Animation<double> animation;
  const _NewsCard({required this.item, required this.animation});

  @override
  State<_NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<_NewsCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColorForItem(context, widget.item);
    final isRecent = DateTime.now().difference(widget.item.date).inHours < 24;
    final relative = _timeAgoEs(widget.item.date);

    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return Opacity(
          opacity: widget.animation.value,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - widget.animation.value)),
            child: Transform.scale(
              scale: 0.9 + (0.1 * widget.animation.value),
              child: child,
            ),
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                accent.withOpacity(0.05),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(_isHovered ? 0.3 : 0.15),
                blurRadius: _isHovered ? 24 : 16,
                offset: Offset(0, _isHovered ? 10 : 6),
                spreadRadius: _isHovered ? 2 : 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: accent.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enhanced emoji badge
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Transform.rotate(
                              angle: (1 - value) * 3.14,
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [_badgeStartForItem(widget.item), accent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _emojiForItem(widget.item),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    color: const Color(0xFF1F2937),
                                    height: 1.3,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: accent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    relative,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: accent,
                                    ),
                                  ),
                                ),
                                if (isRecent) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF4444).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFEF4444),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          'Nuevo',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFEF4444),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.item.summary,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6B7280),
                          height: 1.5,
                          fontSize: 15,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _primaryCtaForItem(widget.item),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: accent,
                            side: BorderSide(color: accent.withOpacity(0.5), width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _secondaryCtaForItem(widget.item),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helpers for look & feel
String _timeAgoEs(DateTime date) {
  final now = DateTime.now();
  final local = date.toLocal();
  final diff = now.difference(local);
  if (diff.inMinutes < 1) return 'Ahora';
  if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'Hoy';
  if (diff.inDays == 1) return 'Ayer';
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
  return '✨';
}

Color _accentColorForItem(BuildContext context, NewsItem item) {
  final lowerTags = item.tags.map((e) => e.toLowerCase()).toList();
  if (lowerTags.any((t) => t.contains('descuento') || t.contains('oferta'))) return const Color(0xFFFF6B35);
  if (lowerTags.any((t) => t.contains('en-vivo') || t.contains('vivo'))) return const Color(0xFFEF4444);
  if (lowerTags.any((t) => t.contains('evento'))) return const Color(0xFF8B5CF6);
  return const Color(0xFF3B82F6);
}

Color _badgeStartForItem(NewsItem item) {
  final lowerTags = item.tags.map((e) => e.toLowerCase()).toList();
  if (lowerTags.any((t) => t.contains('descuento') || t.contains('oferta'))) return const Color(0xFFFBBF24);
  if (lowerTags.any((t) => t.contains('en-vivo') || t.contains('vivo'))) return const Color(0xFFFCA5A5);
  if (lowerTags.any((t) => t.contains('evento'))) return const Color(0xFFC4B5FD);
  return const Color(0xFF93C5FD);
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
