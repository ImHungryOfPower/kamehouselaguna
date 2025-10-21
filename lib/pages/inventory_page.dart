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


class _InventoryPageState extends ConsumerState<InventoryPage> {
    String _filter = 'in_stock'; // 'in_stock' | 'upcoming'


    @override
    Widget build(BuildContext context) {
        final asyncProducts = ref.watch(productsProvider);


        return asyncProducts.when(
            data: (items) {
                final filtered = _filter == 'in_stock'
                    ? items.where((p) => p.stock > 0).toList()
                    : items.where((p) => p.stock == 0).toList();

                return Column(
                    children: [
                        const SizedBox(height: 8),
                        _CatalogHeaderBar(),
                        const SizedBox(height: 12),
                        _FilterChips(
                            filter: _filter,
                            onChanged: (f) => setState(() => _filter = f),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                            child: ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (_, i) => _CatalogCard(p: filtered[i]),
                            ),
                        ),
                    ],
                );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error al cargar inventario\n$e')),
        );
    }
}


class _CatalogHeaderBar extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(16)),
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
    const _FilterChips({required this.filter, required this.onChanged});


    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
                children: [
                    _ChoicePill(
                        label: 'En Stock',
                        selected: filter == 'in_stock',
                        color: const Color(0xFF2ECC71),
                        onTap: () => onChanged('in_stock'),
                    ),
                    const SizedBox(width: 12),
                    _ChoicePill(
                        label: 'Próximamente',
                        selected: filter == 'upcoming',
                        color: const Color(0xFFFF9F43),
                        onTap: () => onChanged('upcoming'),
                    ),
                ],
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
    const _CatalogCard({required this.p});


    @override
    Widget build(BuildContext context) {
        final inStock = p.stock > 0;
        return InkWell(
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
                                                color: inStock ? const Color(0xFF2ECC71) : const Color(0xFFFF9F43),
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
                    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
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