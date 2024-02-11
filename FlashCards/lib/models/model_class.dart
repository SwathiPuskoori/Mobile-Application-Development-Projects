import 'package:flutter/foundation.dart';
import '../utils/db_helper.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class DataNotifier extends ChangeNotifier {
  List<Decks> _decks = [];
  final Map<int, List<Qcards>> _qcardsByDeck = {};

  List<Decks> get decks => _decks;

  DataNotifier() {
    _loadDecks();
  }

  _loadDecks() async {
    final data = await DBHelper().query('decks');
    _decks = data.map((e) => Decks(id: e['id'], name: e['name'])).toList();
    notifyListeners();
  }

  Future<List<dynamic>> loadFlashcardData() async {
    String jsonString = await rootBundle.loadString('assets/flashcards.json');
    return json.decode(jsonString);
  }

  Future<int> getNumberOfCardsForDeck(int deckId) async {
    final data = await DBHelper().query('qcards', where: 'deck_id = $deckId');
    return data.length;
  }

  Future<void> initializeDatabaseFromJson() async {
    List<dynamic> flashcardsData = await loadFlashcardData();

    for (var deckData in flashcardsData) {
      String deckTitle = deckData["title"];
      Decks newDeck = Decks(name: deckTitle);
      await saveDeck(newDeck);
      int deckId = newDeck.id!;

      for (var cardData in deckData["flashcards"]) {
        String question = cardData["question"];
        String answer = cardData["answer"];
        var existingCards = await getQcardsForDeck(deckId);
        if (!existingCards.any((card) => card.question == question)) {
          Qcards newCard =
              Qcards(deckId: deckId, question: question, answer: answer);
          await saveQcard(newCard);
        }
      }
    }
  }

  Future<List<Qcards>> getQcardsForDeck(int deckId) async {
    if (!_qcardsByDeck.containsKey(deckId)) {
      final data = await DBHelper().query('qcards', where: 'deck_id = $deckId');
      _qcardsByDeck[deckId] = data
          .map((e) => Qcards(
              id: e['id'],
              deckId: e['deck_id'],
              question: e['question'],
              answer: e['answer']))
          .toList();
      notifyListeners();
    }
    return _qcardsByDeck[deckId]!;
  }

  Future<void> saveDeck(Decks deck) async {
    deck.id = await DBHelper().insert('decks', {'name': deck.name});
    _loadDecks();
  }

  Future<void> deleteDeck(Decks deck) async {
    if (deck.id != null) {
      await DBHelper().deleteWhere('qcards', 'deck_id', deck.id!);
      await DBHelper().delete('decks', deck.id!);
      _decks.removeWhere((d) => d.id == deck.id);
      _qcardsByDeck.remove(deck.id);
      notifyListeners();
    }
  }

  Future<void> updateDeck(Decks deck) async {
    if (deck.id != null) {
      await DBHelper().update('decks', {'name': deck.name}, deck.id!);
      int indexToUpdate = _decks.indexWhere((d) => d.id == deck.id);
      if (indexToUpdate != -1) {
        _decks[indexToUpdate].name = deck.name;
        notifyListeners();
      }
    }
  }

  Future<void> saveQcard(Qcards qcard) async {
    final dbHelper = DBHelper();
    if (qcard.id != null) {
      await dbHelper.update(
          'qcards',
          {
            'question': qcard.question,
            'answer': qcard.answer,
            'deck_id': qcard.deckId,
          },
          qcard.id!);
    } else {
      qcard.id = await dbHelper.insert('qcards', {
        'question': qcard.question,
        'answer': qcard.answer,
        'deck_id': qcard.deckId,
      });
    }

    if (_qcardsByDeck.containsKey(qcard.deckId)) {
      _qcardsByDeck.remove(qcard.deckId);
    }
    notifyListeners();
  }

  Future<void> deleteQcard(Qcards qcard) async {
    if (qcard.id != null) {
      await DBHelper().delete('qcards', qcard.id!);
      if (_qcardsByDeck.containsKey(qcard.deckId)) {
        _qcardsByDeck.remove(qcard.deckId);
      }
      notifyListeners();
    }
  }
}

class Decks {
  int? id;
  String name;

  Decks({this.id, required this.name});
}

class Qcards {
  int? id;
  final int deckId;
  String question;
  String answer;

  Qcards(
      {this.id,
      required this.deckId,
      required this.question,
      required this.answer});
}
