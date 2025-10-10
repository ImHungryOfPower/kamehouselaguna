class Product {
    final String id;
    final String name;
    final int stock;
    final double price;


Product({
    required this.id,
    required this.name,
    required this.stock,
    required this.price,
});


factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        stock: (json['stock'] as num?)?.toInt() ?? 0,
        price: (json['price'] as num?)?.toDouble() ?? 0,
    );
}