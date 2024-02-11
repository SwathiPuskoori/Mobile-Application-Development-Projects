import 'package:flutter/material.dart';
import '../models/news_model.dart';
import 'home_page.dart';
import 'news_details_page.dart';

class SearchResultsPage extends StatelessWidget {
  final NewsResponse searchResults;

  const SearchResultsPage({Key? key, required this.searchResults})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: searchResults.articles.length,
        itemBuilder: (context, index) {
          final article = searchResults.articles[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailPage(article: article),
                ),
              );
            },
            child: NewsListItem(
              title: article.title,
              imageUrl: article.urlToImage,
            ),
          );
        },
      ),
    );
  }
}
