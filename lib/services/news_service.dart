import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/news_item.dart';


class NewsService {
    Future<List<NewsItem>> fetchNews() async {
        final raw = await rootBundle.loadString('assets/news.json');
        final list = jsonDecode(raw) as List<dynamic>;
        return list.map((e) => NewsItem.fromJson(e as Map<String, dynamic>)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    }
}