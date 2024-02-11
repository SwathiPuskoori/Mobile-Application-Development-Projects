import 'package:flutter/material.dart';
import 'package:mp5/models/bookmarks_model.dart';
import 'package:mp5/views/home_page.dart';
import 'package:mp5/views/news_details_page.dart';
import '../models/news_model.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  BookmarksPageState createState() => BookmarksPageState();
}

class BookmarksPageState extends State<BookmarksPage> {
  Future<List<Article>> _bookmarkedArticlesFuture =
      BookmarkService.getBookmarkedArticles();

  void refreshBookmarksPage() {
    setState(() {
      _bookmarkedArticlesFuture = BookmarkService.getBookmarkedArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: FutureBuilder<List<Article>>(
        future: _bookmarkedArticlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Article> bookmarkedArticles = snapshot.data ?? [];

            return ListView.builder(
              itemCount: bookmarkedArticles.length,
              itemBuilder: (context, index) {
                final article = bookmarkedArticles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailPage(
                          article: article,
                        ),
                      ),
                    ).then((value) {
                      refreshBookmarksPage();
                    });
                  },
                  child: NewsListItem(
                    title: article.title,
                    imageUrl: article.urlToImage,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
