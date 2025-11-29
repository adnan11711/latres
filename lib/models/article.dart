class Article {
  final int id;
  final String title;
  final String imageUrl;
  final String summary;
  final String publishedAt;
  final String url;

  Article({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.summary,
    required this.publishedAt,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'] ?? '',
      summary: json['summary'] ?? '',
      publishedAt: json['published_at'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
