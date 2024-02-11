import 'package:flutter/material.dart';
import 'package:mp3/views/decklist.dart';
import 'package:provider/provider.dart';
import '../models/model_class.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataNotifier(),
      child: const QuizApp(),
    ),
  );
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: DeckList());
  }
}
