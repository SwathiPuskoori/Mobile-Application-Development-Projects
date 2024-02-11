import 'package:mp5/views/settings_page.dart';

class TopHeadlinesDefaults {
  final String country;
  final String category;
  final String language;
  final int pageSize;
  final int page;

  TopHeadlinesDefaults({
    required this.country,
    required this.category,
    required this.language,
    required this.pageSize,
    required this.page,
  });

  static Future<TopHeadlinesDefaults> createDefaults() async {
    return TopHeadlinesDefaults(
      country: await SettingsService.getCountry() ?? 'us',
      category: await SettingsService.getCategory() ?? 'general',
      language: await SettingsService.getLanguage() ?? 'en',
      pageSize: 20,
      page: 1,
    );
  }
}
