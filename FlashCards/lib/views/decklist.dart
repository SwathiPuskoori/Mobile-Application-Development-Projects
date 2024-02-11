import 'package:flutter/material.dart';
import 'package:mp3/views/deckinput.dart';
import 'package:mp3/views/quizlist.dart';
import 'package:provider/provider.dart';
import '../models/model_class.dart';

class DeckList extends StatefulWidget {
  const DeckList({Key? key}) : super(key: key);

  @override
  State<DeckList> createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    const double desiredCardWidth = 200.0;
    int cardsWidth = (screenWidth / desiredCardWidth).floor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Decks'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () async {
              final dataNotifier =
                  Provider.of<DataNotifier>(context, listen: false);
              await dataNotifier.initializeDatabaseFromJson();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DeckNameInputPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<DataNotifier>(
        builder: (context, dataNotifier, _) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cardsWidth,
            childAspectRatio: 1,
          ),
          itemCount: dataNotifier.decks.length,
          itemBuilder: (context, index) {
            final deck = dataNotifier.decks[index];
            return _buildDeckCard(deck);
          },
        ),
      ),
    );
  }

  Widget _buildDeckCard(Decks deck) {
    return FutureBuilder<int>(
        future: Provider.of<DataNotifier>(context, listen: false)
            .getNumberOfCardsForDeck(deck.id!),
        builder: (context, snapshot) {
          int numberOfCards = snapshot.data ?? 0;

          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuizList(deck: deck),
              ),
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: const Color.fromARGB(255, 245, 221, 133),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      deck.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        '$numberOfCards cards',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DeckNameInputPage(deck: deck),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
