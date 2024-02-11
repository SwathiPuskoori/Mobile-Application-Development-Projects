import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _countryKey = 'country';
  static const String _categoryKey = 'category';
  static const String _languageKey = 'language';

  static Future<void> saveCountry(String country) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_countryKey, country);
  }

  static Future<String?> getCountry() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_countryKey);
  }

  static Future<void> saveCategory(String category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_categoryKey, category);
  }

  static Future<String?> getCategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_categoryKey);
  }

  static Future<void> saveLanguage(String language) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_languageKey, language);
  }

  static Future<String?> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  String? selectedCountry;
  String? selectedCategory;
  String? selectedLanguage;

  final Map<String, String> countryMap = {
    'ae': 'United Arab Emirates',
    'ar': 'Argentina',
    'at': 'Austria',
    'au': 'Australia',
    'be': 'Belgium',
    'bg': 'Bulgaria',
    'br': 'Brazil',
    'ca': 'Canada',
    'ch': 'Switzerland',
    'cn': 'China',
    'co': 'Colombia',
    'cu': 'Cuba',
    'cz': 'Czech Republic',
    'de': 'Germany',
    'eg': 'Egypt',
    'fr': 'France',
    'gb': 'United Kingdom',
    'gr': 'Greece',
    'hk': 'Hong Kong',
    'hu': 'Hungary',
    'id': 'Indonesia',
    'ie': 'Ireland',
    'il': 'Israel',
    'in': 'India',
    'it': 'Italy',
    'jp': 'Japan',
    'kr': 'South Korea',
    'lt': 'Lithuania',
    'lv': 'Latvia',
    'ma': 'Morocco',
    'mx': 'Mexico',
    'my': 'Malaysia',
    'ng': 'Nigeria',
    'nl': 'Netherlands',
    'no': 'Norway',
    'nz': 'New Zealand',
    'ph': 'Philippines',
    'pl': 'Poland',
    'pt': 'Portugal',
    'ro': 'Romania',
    'rs': 'Serbia',
    'ru': 'Russia',
    'sa': 'Saudi Arabia',
    'se': 'Sweden',
    'sg': 'Singapore',
    'sk': 'Slovakia',
    'si': 'Slovenia',
    'th': 'Thailand',
    'tr': 'Turkey',
    'tw': 'Taiwan',
    'ua': 'Ukraine',
    'us': 'United States',
    've': 'Venezuela',
    'za': 'South Africa',
  };

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    selectedCountry = await SettingsService.getCountry() ?? 'us';
    selectedCategory = await SettingsService.getCategory() ?? 'general';
    selectedLanguage = await SettingsService.getLanguage() ?? 'en';
    setState(() {});
  }

  Future<void> saveSettings() async {
    await SettingsService.saveCountry(selectedCountry!);
    await SettingsService.saveCategory(selectedCategory!);
    await SettingsService.saveLanguage(selectedLanguage!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedCountry,
              items: countryMap.keys
                  .map((countryCode) => DropdownMenuItem(
                        value: countryCode,
                        child: Text(countryMap[countryCode]!),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCountry = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Country'),
            ),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: [
                'general',
                'business',
                'entertainment',
                'health',
                'science',
                'sports',
                'technology'
              ]
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              items:
                  ['en', 'es', 'fr', 'de', 'it']
                      .map((language) => DropdownMenuItem(
                            value: language,
                            child: Text(language),
                          ))
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Language'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await saveSettings();
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
