import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart';


class InventoryService {
    Future<List<Product>> fetchProducts() async {
        final raw = await rootBundle.loadString('assets/products.json');
        final list = jsonDecode(raw) as List<dynamic>;
        return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
}