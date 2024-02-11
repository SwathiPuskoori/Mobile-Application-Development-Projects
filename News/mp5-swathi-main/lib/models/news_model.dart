class NewsResponse {
  String status;
  int totalResults;
  List<Article> articles;

  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    var articlesList = json['articles'] as List;
    List<Article> articles =
        articlesList.map((article) => Article.fromJson(article)).toList();

    return NewsResponse(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: articles,
    );
  }
}

class Article {
  String sourceId;
  String sourceName;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;

  Article({
    required this.sourceId,
    required this.sourceName,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'source': {
        'id': sourceId,
        'name': sourceName,
      },
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> source = json['source'];
    return Article(
      sourceId: source['id'] ?? "",
      sourceName: source['name'] ?? "",
      author: json['author'] ?? "",
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      url: json['url'] ?? "",
      urlToImage: json['urlToImage'] ?? "",
      publishedAt: json['publishedAt'] ?? "",
      content: json['content'] ?? "",
    );
  }
}
