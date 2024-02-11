import 'package:flutter/material.dart';
import 'package:mp5/models/bookmarks_model.dart';
import '../models/news_model.dart';

class NewsDetailPage extends StatefulWidget {
  final Article article;

  const NewsDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  NewsDetailPageState createState() => NewsDetailPageState();
}

class NewsDetailPageState extends State<NewsDetailPage> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    checkBookmarkStatus();
  }

  Future<void> checkBookmarkStatus() async {
    isBookmarked = await BookmarkService.isBookmarked(widget.article.url);
    setState(() {});
  }

  Future<void> toggleBookmarkStatus() async {
    if (isBookmarked) {
      await BookmarkService.removeBookmark(widget.article.url);
      if (!mounted) return;
    } else {
      await BookmarkService.addBookmark(widget.article);
    }
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.title),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.star : Icons.star_border,
            ),
            onPressed: toggleBookmarkStatus,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (Uri.parse(widget.article.urlToImage).isAbsolute)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  widget.article.urlToImage,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16.0),
            Text(
              widget.article.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.article.description,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Author: ${widget.article.author}',
              style: const TextStyle(
                fontSize: 14.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Published At: ${widget.article.publishedAt}',
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'url: ${widget.article.url}',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
