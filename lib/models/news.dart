class News {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String publishedAt;
  bool isBookmarked;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    this.isBookmarked = false,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      source: json['source'] as String,
      publishedAt: json['publishedAt'] as String,
      isBookmarked: json['isBookmarked'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'source': source,
      'publishedAt': publishedAt,
      'isBookmarked': isBookmarked,
    };
  }
}
