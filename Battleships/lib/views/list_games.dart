import 'package:battleships/model/game_model.dart';
import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/game_view.dart';
import 'package:battleships/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameListPage extends StatefulWidget {
  const GameListPage({Key? key}) : super(key: key);

  @override
  GameListPageState createState() => GameListPageState();
}

class GameListPageState extends State<GameListPage> {
  List<Game> games = [];
  bool showCompletedGames = false;
  String username = '';

  @override
  void initState() {
    super.initState();
    _fetchGames();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    setState(() async {
      username = await SessionManager.getUsernamen();
    });
  }

  Future<void> _logout() async {
    await SessionManager.clearSession();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }

  Future<void> _fetchGames() async {
    final accessToken = await SessionManager.getSessionToken();
    final response = await http.get(Uri.parse('http://165.227.117.48/games'),
        headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      final gamesJson = jsonDecode(response.body)['games'];
      if (gamesJson is List) {
        final filteredGames = gamesJson
            .map<Game>((gameJson) => Game.fromJson(gameJson))
            .where((game) => showCompletedGames
                ? game.status == 1 || game.status == 2
                : game.status == 0 || game.status == 3)
            .toList();
        setState(() => games = filteredGames);
      }
    } else if (response.statusCode == 401) {
      final responseBodyLog = jsonDecode(response.body);
      if (responseBodyLog['message'] == "Invalid token") {
        _logout();
      }
    }
  }

  Future<void> _startNewGameWithHuman() async {
    final accessToken = await SessionManager.getSessionToken();
    if (!mounted) return;
    final selectedShips = await Navigator.of(context).push<List<String>>(
        MaterialPageRoute(
            builder: (context) => GameViewPage(
                accessToken: accessToken, gameId: 0, isNewGame: true)));
    if (selectedShips!.length == 5) {
      final requestBody = {'ships': selectedShips};
      final response = await http.post(Uri.parse('http://165.227.117.48/games'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody));
      if (response.statusCode == 200) {
        await _fetchGames();
      } else if (response.statusCode == 401) {
        final responseBodyLog = jsonDecode(response.body);
        if (responseBodyLog['message'] == "Invalid token") {
          _logout();
        }
      }
    }
  }

  Future<void> _startGameWithAi(String aiType) async {
    Navigator.pop(context);
    final accessToken = await SessionManager.getSessionToken();
    if (!mounted) return;
    final selectedShips = await Navigator.of(context).push<List<String>>(
        MaterialPageRoute(
            builder: (context) => GameViewPage(
                accessToken: accessToken, gameId: 0, isNewGame: true)));
    if (selectedShips == null) return;
    final Uri url = Uri.parse('http://165.227.117.48/games');
    final requestBody = {'ships': selectedShips, 'ai': aiType};
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(requestBody));
    if (response.statusCode == 200) {
      await _fetchGames();
    } else if (response.statusCode == 401) {
      final responseBodyLog = jsonDecode(response.body);
      if (responseBodyLog['message'] == "Invalid token") {
        _logout();
      }
    }
  }

  Future<void> _navigateToGameView(int gameId) async {
    final accessToken = await SessionManager.getSessionToken();
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GameViewPage(
            accessToken: accessToken, gameId: gameId, isNewGame: false)));
    await _fetchGames();
  }

  String _buildTitle(Game game) {
    if (game.status == 0) {
      return '#${game.id} Waiting for opponent';
    } else {
      return '#${game.id} ${game.player1} vs ${game.player2}';
    }
  }

  Future<void> _toggleShowCompletedGames() async {
    setState(() {
      showCompletedGames = !showCompletedGames;
    });
    await _fetchGames();
  }

  Widget _buildDialogOption(String title, VoidCallback onTap) {
    return InkWell(
        onHover: (value) {
          setState(() {});
        },
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [Text(title)])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Game List'), actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchGames)
        ]),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Battleships',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 8),
                    Text('Logged in as $username',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
                  ])),
          ListTile(
              leading: const Icon(Icons.gamepad),
              title: const Text('New Game'),
              onTap: () {
                Navigator.pop(context);
                _startNewGameWithHuman();
              }),
          ListTile(
              leading: const Icon(Icons.android),
              title: const Text('New Game (AI)'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                        'Which AI do you want to play against?',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        )),
                                    const SizedBox(height: 16.0),
                                    _buildDialogOption('Random',
                                        () => _startGameWithAi('random')),
                                    const SizedBox(height: 16.0),
                                    _buildDialogOption('Perfect',
                                        () => _startGameWithAi('perfect')),
                                    const SizedBox(height: 16.0),
                                    _buildDialogOption('One Ship (A1)',
                                        () => _startGameWithAi('oneship'))
                                  ])));
                    });
              }),
          ListTile(
              leading: showCompletedGames
                  ? const Icon(Icons.running_with_errors)
                  : const Icon(Icons.history),
              title: showCompletedGames
                  ? const Text('Active Games')
                  : const Text('Completed Games'),
              onTap: () {
                Navigator.pop(context);
                _toggleShowCompletedGames();
              }),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log out'),
              onTap: () {
                Navigator.pop(context);
                _logout();
              })
        ])),
        body: RefreshIndicator(
            onRefresh: _fetchGames,
            child: ListView.builder(
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  return (game.status == 0 || game.status == 3)
                      ? Dismissible(
                          key: Key(game.id.toString()),
                          background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              child: const Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child:
                                      Icon(Icons.delete, color: Colors.white))),
                          confirmDismiss: (direction) async => true,
                          onDismissed: (direction) {
                            _deleteGame(game.id, index);
                            showSnackBar('Game forfeited');
                          },
                          child: ListTile(
                              title: Text(_buildTitle(game)),
                              trailing: Text((game.status == 3
                                  ? (game.getPlayerName(game.turn) == username
                                      ? 'myTurn'
                                      : "opponentTurn")
                                  : 'matchmaking')),
                              onTap: () => _navigateToGameView(game.id)))
                      : ListTile(
                          title: Text(_buildTitle(game)),
                          trailing: Text((game.status == 1
                              ? (game.player1 == username
                                  ? 'gameWon'
                                  : 'gameLost')
                              : game.player2 == username
                                  ? 'gameWon'
                                  : 'gameLost')),
                          onTap: () => _navigateToGameView(game.id));
                })));
  }

  void showSnackBar(String message) {
    final snackBar =
        SnackBar(content: Text(message), duration: const Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _deleteGame(int gameId, int index) async {
    final accessToken = await SessionManager.getSessionToken();
    if (games[index].status == 0 || games[index].status == 3) {
      final response = await http.delete(
          Uri.parse('http://165.227.117.48/games/$gameId'),
          headers: {'Authorization': 'Bearer $accessToken'});
      if (response.statusCode == 200) {
        await _fetchGames();
        setState(() => games.removeAt(index));
        await _fetchGames();
      } else if (response.statusCode == 401) {
        final responseBodyLog = jsonDecode(response.body);
        if (responseBodyLog['message'] == "Invalid token") {
          _logout();
        }
      }
    }
  }
}
