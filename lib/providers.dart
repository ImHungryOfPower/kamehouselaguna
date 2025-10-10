import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/news_service.dart';
import 'services/inventory_service.dart';
import 'services/random_message_service.dart';
import 'services/notifications_service.dart';
import 'models/news_item.dart';
import 'models/product.dart';


final newsServiceProvider = Provider<NewsService>((ref) => NewsService());
final inventoryServiceProvider = Provider<InventoryService>((ref) => InventoryService());
final randomMessageServiceProvider = Provider<RandomMessageService>((ref) => RandomMessageService());
final notificationsServiceProvider = Provider<NotificationsService>((ref) => NotificationsService());


final newsProvider = FutureProvider<List<NewsItem>>(
    (ref) => ref.read(newsServiceProvider).fetchNews(),
);


final productsProvider = FutureProvider<List<Product>>(
    (ref) => ref.read(inventoryServiceProvider).fetchProducts(),
);