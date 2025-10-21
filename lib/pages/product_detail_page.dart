import 'package:flutter/material.dart';
import '../models/product.dart';


class ProductDetailPage extends StatefulWidget {
    final Product product;
    final String emoji; // lightweight visual for the mock image
    const ProductDetailPage({super.key, required this.product, required this.emoji});


    @override
    State<ProductDetailPage> createState() => _ProductDetailPageState();
}


class _ProductDetailPageState extends State<ProductDetailPage> {
    bool _favorite = false;
    bool _addedToCart = false;


    @override
    Widget build(BuildContext context) {
        final inStock = widget.product.stock > 0;
        return Scaffold(
            body: Container(
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
                child: SafeArea(
                child: Column(
                    children: [
                        _buildHeader(context),
                        Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                        _buildImageSection(inStock: inStock),
                                        _buildInfoSection(inStock: inStock),
                                        _buildFeaturesSection(),
                                        const SizedBox(height: 90), // spacer for bottom bar
                                    ],
                                ),
                            ),
                        ),
                        _buildBottomBar(),
                    ],
                ),
                ),
            ),
        );
    }


    Widget _buildHeader(BuildContext context) {
        return Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8C42), Color(0xFFFFD700)], // Naranja a Dorado DBZ
                ),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Row(
                        children: [
                            _headerButton(
                                icon: Icons.arrow_back,
                                onTap: () => Navigator.of(context).maybePop(),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                                'Detalle del Producto',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                        ],
                    ),
                    Row(
                        children: [
                            _headerButton(
                                icon: _favorite ? Icons.favorite : Icons.favorite_border,
                                onTap: () => setState(() => _favorite = !_favorite),
                            ),
                            const SizedBox(width: 8),
                            _headerButton(
                                icon: Icons.ios_share,
                                onTap: () {},
                            ),
                        ],
                    ),
                ],
            ),
        );
    }


    Widget _headerButton({required IconData icon, required VoidCallback onTap}) {
        return InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
            ),
        );
    }


    Widget _buildImageSection({required bool inStock}) {
        return Container(
            height: 250,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8C42), Color(0xFFFFB347)], // Naranja Dragon Ball
                ),
            ),
            child: Stack(
                children: [
                    Center(
                        child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 32,
                                        offset: const Offset(0, 8),
                                    ),
                                ],
                            ),
                            child: Center(
                                child: Text(
                                    widget.emoji,
                                    style: const TextStyle(fontSize: 80, color: Colors.white),
                                ),
                            ),
                        ),
                    ),
                    Positioned(
                        right: 16,
                        top: 16,
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                                color: inStock ? const Color(0xFFEF4444) : const Color(0xFFFFD700), // Rojo Kaio-ken / Dorado
                                borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                                inStock ? 'Nuevo' : 'Próximo',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                        ),
                    ),
                ],
            ),
        );
    }


    Widget _buildInfoSection({required bool inStock}) {
        final p = widget.product;
        return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        p.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF2D3748)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        _subtitleFor(p.name),
                        style: const TextStyle(fontSize: 16, color: Color(0xFF718096)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                        '\$${p.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFFFF6B35)),
                    ),
                    const SizedBox(height: 12),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            color: inStock ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7), // Verde/Amarillo pastel
                            borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                            inStock ? 'En Stock' : 'Próximamente',
                            style: TextStyle(
                                color: inStock ? const Color(0xFF10B981) : const Color(0xFFFF8C42), // Verde Namek / Naranja
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                            ),
                        ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                        _descriptionFor(p.name),
                        style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568), height: 1.6),
                    ),
                ],
            ),
        );
    }


    Widget _buildFeaturesSection() {
        const features = <String>[
            'Altura: 18 cm',
            'Material: PVC de alta calidad',
            'Accesorios intercambiables',
            'Base de exhibición incluida',
            'Edición limitada',
        ];
        return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    const Text(
                        'Características',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2D3748)),
                    ),
                    const SizedBox(height: 16),
                    Column(
                        children: [
                            for (final f in features) _featureItem(f),
                        ],
                    ),
                ],
            ),
        );
    }


    Widget _featureItem(String text) {
        return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
                children: [
                    const _FeatureDot(),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(
                            text,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF2D3748), fontWeight: FontWeight.w500),
                        ),
                    ),
                ],
            ),
        );
    }


    Widget _buildBottomBar() {
        return Container(
            height: 72,
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    OutlinedButton(
                        onPressed: () => setState(() => _favorite = !_favorite),
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            side: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
                        ),
                        child: Text(_favorite ? '❤️ Agregado' : '❤️ Favoritos', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    ElevatedButton(
                        onPressed: _addedToCart ? null : () => setState(() => _addedToCart = true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: Text(_addedToCart ? '✓ Agregado' : 'Agregar al Carrito', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                ],
            ),
        );
    }


    String _subtitleFor(String name) {
        return 'Artículo de colección premium con detalles y accesorios';
    }


    String _descriptionFor(String name) {
        return 'Pieza de colección con acabados de alta calidad y accesorios intercambiables. Ideal para exhibición o regalo para fans.';
    }
}


class _FeatureDot extends StatelessWidget {
    const _FeatureDot();


    @override
    Widget build(BuildContext context) {
        return Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
                child: Icon(Icons.check, color: Colors.white, size: 16),
            ),
        );
    }
}

