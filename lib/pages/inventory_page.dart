import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/product.dart';
import 'product_detail_page.dart';


class InventoryPage extends ConsumerStatefulWidget {
    const InventoryPage({super.key});


    @override
    ConsumerState<InventoryPage> createState() => _InventoryPageState();
}


class _InventoryPageState extends ConsumerState<InventoryPage> with SingleTickerProviderStateMixin {
    String _filter = 'in_stock'; // 'in_stock' | 'upcoming'
    late AnimationController _animController;

    @override
    void initState() {
        super.initState();
        _animController = AnimationController(
            duration: const Duration(milliseconds: 1000),
            vsync: this,
        );
        _animController.forward();
    }

    @override
    void dispose() {
        _animController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final asyncProducts = ref.watch(productsProvider);


        return asyncProducts.when(
            data: (items) {
                final filtered = _filter == 'in_stock'
                    ? items.where((p) => p.stock > 0).toList()
                    : items.where((p) => p.stock == 0).toList();

                return AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFFFE5B4), // Naranja crema
                                Color(0xFFFFF5E6), // Crema suave
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                                const SizedBox(height: 8),
                                _CatalogHeaderBar(animation: _animController),
                                const SizedBox(height: 12),
                                _FilterChips(
                                    filter: _filter,
                                    onChanged: (f) => setState(() => _filter = f),
                                    animation: _animController,
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                    child: ListView.separated(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        itemCount: filtered.length,
                                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                                        itemBuilder: (_, i) {
                                            final animation = CurvedAnimation(
                                                parent: _animController,
                                                curve: Interval(
                                                    (i * 0.08).clamp(0.0, 0.8),
                                                    (i * 0.08 + 0.4).clamp(0.0, 1.0),
                                                    curve: Curves.easeOutBack,
                                                ),
                                            );
                                            return _CatalogCard(p: filtered[i], animation: animation);
                                        },
                                    ),
                                ),
                            ],
                          ),
                        );
                    },
                );
            },
            loading: () => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFE5B4), Color(0xFFFFF5E6)],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                ),
              ),
            ),
            error: (e, st) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFE5B4), Color(0xFFFFF5E6)],
                ),
              ),
              child: Center(child: Text('Error al cargar inventario\n$e')),
            ),
        );
    }
}


class _CatalogHeaderBar extends StatelessWidget {
    final Animation<double> animation;
    const _CatalogHeaderBar({required this.animation});

    @override
    Widget build(BuildContext context) {
        return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
                return Opacity(
                    opacity: animation.value,
                    child: Transform.translate(
                        offset: Offset(0, -30 * (1 - animation.value)),
                        child: child,
                    ),
                );
            },
            child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8C42), Color(0xFFFFD700)], // Naranja a Dorado DBZ
                ),
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFF6B35),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                    Text(
                        'Catálogo de Figuras',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Row(
                        children: [
                            _HeaderIcon(icon: Icons.search),
                            SizedBox(width: 8),
                            _HeaderIcon(icon: Icons.notifications),
                        ],
                    ),
                ],
            ),
        ),
        );
    }
}


class _HeaderIcon extends StatelessWidget {
    final IconData icon;
    const _HeaderIcon({required this.icon});


    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
        );
    }
}


class _FilterChips extends StatelessWidget {
    final String filter;
    final ValueChanged<String> onChanged;
    final Animation<double> animation;
    const _FilterChips({required this.filter, required this.onChanged, required this.animation});


    @override
    Widget build(BuildContext context) {
        return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
                return Opacity(
                    opacity: animation.value,
                    child: Transform.scale(
                        scale: 0.8 + (0.2 * animation.value),
                        child: child,
                    ),
                );
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                children: [
                    _ChoicePill(
                        label: 'En Stock',
                        selected: filter == 'in_stock',
                        color: const Color(0xFF10B981), // Verde Namek
                        onTap: () => onChanged('in_stock'),
                    ),
                    const SizedBox(width: 12),
                    _ChoicePill(
                        label: 'Próximamente',
                        selected: filter == 'upcoming',
                        color: const Color(0xFFFFD700), // Dorado Super Saiyan
                        onTap: () => onChanged('upcoming'),
                    ),
                ],
            ),
            ),
        );
    }
}


class _ChoicePill extends StatelessWidget {
    final String label;
    final bool selected;
    final Color color;
    final VoidCallback onTap;
    const _ChoicePill({required this.label, required this.selected, required this.color, required this.onTap});


    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                    color: selected ? color : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                    label,
                    style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                    ),
                ),
            ),
        );
    }
}


class _CatalogCard extends StatelessWidget {
    final Product p;
    final Animation<double> animation;
    const _CatalogCard({required this.p, required this.animation});


    @override
    Widget build(BuildContext context) {
        final inStock = p.stock > 0;
        return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
                return Opacity(
                    opacity: animation.value,
                    child: Transform.translate(
                        offset: Offset(50 * (1 - animation.value), 0),
                        child: Transform.scale(
                            scale: 0.9 + (0.1 * animation.value),
                            child: child,
                        ),
                    ),
                );
            },
            child: InkWell(
            onTap: () {
                final emoji = _emojiFor(p.name);
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: p, emoji: emoji),
                    ),
                );
            },
            child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                    ),
                ],
            ),
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        _EmojiThumb(emoji: _emojiFor(p.name)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Row(
                                        children: [
                                            Expanded(
                                                child: Text(
                                                    p.name,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w700,
                                                    ),
                                                ),
                                            ),
                            _StatusPill(
                                label: inStock ? 'En Stock' : 'Próximamente',
                                color: inStock ? const Color(0xFF10B981) : const Color(0xFFFFD700),
                            ),
                                        ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                        inStock
                                            ? 'Stock: ${p.stock}  •  Precio: \$${p.price.toStringAsFixed(2)}'
                                            : 'Precio estimado: \$${p.price.toStringAsFixed(2)}',
                                        style: TextStyle(color: Colors.grey.shade700),
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
                ),
            ),
            ),
        );
    }


    String _emojiFor(String name) {
        const pool = ['🤖','⚔️','🌙','🃏','🐉','🧙‍♂️','🛡️','🚀'];
        if (name.isEmpty) return '📦';
        final i = name.codeUnits.fold<int>(0, (a, b) => a + b) % pool.length;
        return pool[i];
    }
}


class _EmojiThumb extends StatelessWidget {
    final String emoji;
    const _EmojiThumb({required this.emoji});


    @override
    Widget build(BuildContext context) {
        return Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)], // Naranja Dragon Ball
                ),
            ),
            child: Center(
                child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 28),
                ),
            ),
        );
    }
}


class _StatusPill extends StatelessWidget {
    final String label;
    final Color color;
    const _StatusPill({required this.label, required this.color});


    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
                label,
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
            ),
        );
    }
}