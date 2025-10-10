class NewsItem {
    final String id;
    final String title;
    final String summary;
    final DateTime date;
    final String image;
    final List<String> tags;


NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.date,
    required this.image,
    required this.tags,
});


factory NewsItem.fromJson(Map<String, dynamic> json) => NewsItem(
        id: json['id'].toString(),
        title: json['title'] ?? '',
        summary: json['summary'] ?? '',
        date: DateTime.parse(json['date'] as String),
        image: json['image'] ?? '',
        tags: (json['tags'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
    );
}