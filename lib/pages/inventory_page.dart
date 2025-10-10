import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/product.dart';


class InventoryPage extends ConsumerWidget {
    const InventoryPage({super.key});


    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final asyncProducts = ref.watch(productsProvider);


        return asyncProducts.when(
            data: (items) => ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (_, i) => _ProductTile(p: items[i]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error al cargar inventario\n$e')),
        );
    }
}


class _ProductTile extends StatelessWidget {
    final Product p;
    const _ProductTile({required this.p});


    @override
    Widget build(BuildContext context) {
        final inStock = p.stock > 0;
        return ListTile(
            leading: CircleAvatar(child: Text(p.name.isNotEmpty ? p.name[0] : '?')),
            title: Text(p.name),
            subtitle: Text('Stock: ${p.stock}'),
            trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text('\$${p.price.toStringAsFixed(2)}'),
                    const SizedBox(height: 4),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: inStock ? Colors.green.withOpacity(.12) : Colors.red.withOpacity(.12),
                            borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                            inStock ? 'Disponible' : 'Agotado',
                            style: TextStyle(color: inStock ? Colors.green[700] : Colors.red[700], fontSize: 12),
                        ),
                    ),
                ],
            ),
        );
    }
}