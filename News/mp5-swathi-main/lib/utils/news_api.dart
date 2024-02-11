import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/defaults_settings.dart';
import '../models/news_model.dart';

class NewsApiClient {
  final String apiKey;
  final String baseUrl = "https://newsapi.org/v2/everything";
  final String topHeadlinesUrl = "https://newsapi.org/v2/top-headlines";

  NewsApiClient({required this.apiKey});

  Future<NewsResponse> getNews({
    String? q,
    String? searchIn,
    String? sources,
    String? domains,
    String? excludeDomains,
    String? from,
    String? to,
    String? language,
    String? sortBy,
    int? pageSize,
    int? page,
  }) async {
    final Map<String, String> parameters = {
      'apiKey': apiKey,
      if (q != null) 'q': q,
      if (searchIn != null) 'searchIn': searchIn,
      if (sources != null) 'sources': sources,
      if (domains != null) 'domains': domains,
      if (excludeDomains != null) 'excludeDomains': excludeDomains,
      if (from != null) 'from': from,
      if (to != null) 'to': to,
      if (language != null) 'language': language,
      if (sortBy != null) 'sortBy': sortBy,
      if (pageSize != null) 'pageSize': pageSize.toString(),
      if (page != null) 'page': page.toString(),
    };

    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: parameters);
    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return NewsResponse.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<NewsResponse> getTopHeadlines({
    String? country,
    String? category,
    String? sources,
    String? q,
    int? pageSize,
    int? page,
  }) async {
    final TopHeadlinesDefaults defaults =
        await TopHeadlinesDefaults.createDefaults();

    final Map<String, String> parameters = {
      'apiKey': apiKey,
      'country': country ?? defaults.country,
      'category': category ?? defaults.category,
      'pageSize': (pageSize ?? defaults.pageSize).toString(),
      'page': (page ?? defaults.page).toString(),
    };

    final Uri uri =
        Uri.parse(topHeadlinesUrl).replace(queryParameters: parameters);
    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return NewsResponse.fromJson(data);
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
}
