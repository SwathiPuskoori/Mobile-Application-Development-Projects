import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GameViewPage extends StatefulWidget {
  final String accessToken;
  final int gameId;
  final bool isNewGame;

  const GameViewPage({
    Key? key,
    required this.accessToken,
    required this.gameId,
    required this.isNewGame,
  }) : super(key: key);

  @override
  GameViewPageState createState() => GameViewPageState();
}

class GameViewPageState extends State<GameViewPage> {
  List<String> placedShips = [];
  String hoverPosition = '';
  List<String> ships = [];
  List<String> wrecks = [];
  List<String> shots = [];
  List<String> sunk = [];
  bool isPlayingShot = false;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    fetchGameDetails();
  }

  Future<void> fetchGameDetails() async {
    final response = await http.get(
      Uri.parse('http://165.227.117.48/games/${widget.gameId}'),
      headers: {'Authorization': 'Bearer ${widget.accessToken}'},
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] != 3) {
        gameOver = true;
      }
      setState(() {
        ships = List<String>.from(responseBody['ships']);
        wrecks = List<String>.from(responseBody['wrecks']);
        shots = List<String>.from(responseBody['shots']);
        sunk = List<String>.from(responseBody['sunk']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNewGame ? 'Place ships' : 'Play game'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 20,
            child: buildGameGridView(),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                if (widget.isNewGame) {
                  handleSubmit();
                } else {
                  if (gameOver) {
                    return;
                  }
                  handleShotSubmission();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: gameOver ? Colors.grey : null,
              ),
              child: const Text('Submit'),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildGameGridView() {
    double maxWidth = MediaQuery.of(context).size.shortestSide * 0.85;
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 1.0,
          ),
          itemCount: 36,
          itemBuilder: (context, index) {
            int row = index ~/ 6;
            int col = index % 6;

            if (row == 0 || col == 0) {
              return buildHeadingCell(row, col);
            } else {
              return buildInnerCell(row, col);
            }
          },
        ),
      ),
    );
  }

  Widget buildHeadingCell(int row, int col) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          col == 0 ? (row == 0 ? '' : String.fromCharCode(row + 64)) : '$col',
        ),
      ),
    );
  }

  Widget buildInnerCell(int row, int col) {
    bool isShipPlaced = placedShips.contains(convertToGridPosition(row, col));

    return InkWell(
      onTap: () {
        if (!isPlayingShot) {
          handleShipPlacement(row, col);
        }
      },
      onHover: (value) {
        if (!isPlayingShot) {
          handleHover(value, row, col);
        }
      },
      child: Container(
        color: getCellColor(row, col, isShipPlaced),
        child: Center(
          child: getCellContent(convertToGridPosition(row, col), isShipPlaced),
        ),
      ),
    );
  }

  Color? getCellColor(int row, int col, bool isShipPlaced) {
    if (isShipPlaced) {
      return widget.isNewGame ? Colors.green[100] : Colors.red[100];
    } else {
      return (hoverPosition == convertToGridPosition(row, col)
          ? (widget.isNewGame ? Colors.green[50] : Colors.red[50])
          : Colors.white);
    }
  }

  Widget getCellContent(String position, bool isShipPlaced) {
    bool isShotByYou = shots.contains(position);
    bool isYourShip = ships.contains(position);

    if (wrecks.contains(position) && sunk.contains(position)) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🫧', style: TextStyle(fontSize: 20)),
          SizedBox(width: 4),
          Text('💥', style: TextStyle(fontSize: 20)),
        ],
      );
    } else if (isYourShip && sunk.contains(position)) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🚢', style: TextStyle(fontSize: 20)),
          SizedBox(width: 4),
          Text('💥', style: TextStyle(fontSize: 20)),
        ],
      );
    } else if (isYourShip && isShotByYou) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🚢', style: TextStyle(fontSize: 20)),
          SizedBox(width: 4),
          Text('💣', style: TextStyle(fontSize: 20)),
        ],
      );
    } else if (wrecks.contains(position) && isShotByYou) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🫧', style: TextStyle(fontSize: 20)),
          SizedBox(width: 4),
          Text('💣', style: TextStyle(fontSize: 20)),
        ],
      );
    } else if (sunk.contains(position)) {
      return const Text('💥', style: TextStyle(fontSize: 20));
    } else if (isYourShip) {
      return const Text('🚢', style: TextStyle(fontSize: 20));
    } else if (wrecks.contains(position)) {
      return const Text('🫧', style: TextStyle(fontSize: 20));
    } else if (isShotByYou) {
      return const Text('💣', style: TextStyle(fontSize: 20));
    } else {
      return const Text('');
    }
  }

  String convertToGridPosition(int row, int col) {
    return '${String.fromCharCode(row + 64)}$col';
  }

  void handleShipPlacement(int row, int col) {
    String position = convertToGridPosition(row, col);
    setState(() {
      if (widget.isNewGame) {
        toggleShipPosition(position);
      } else {
        placedShips.clear();
        toggleShipPosition(position);
      }
    });
  }

  void toggleShipPosition(String position) {
    if (placedShips.contains(position)) {
      placedShips.remove(position);
    } else if (placedShips.length < 5) {
      placedShips.add(position);
    }
  }

  void handleHover(bool isHovered, int row, int col) {
    setState(() {
      hoverPosition = isHovered ? convertToGridPosition(row, col) : '';
    });
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handleSubmit() {
    fetchGameDetails();
    if (placedShips.length != 5) {
      showSnackBar("You must place five ships");
    } else {
      Navigator.of(context).pop(placedShips);
    }
  }

  void handleShotSubmission() async {
    String selectedPosition = placedShips.first;
    Map<String, String> requestBody = {'shot': selectedPosition};
    final response = await http.put(
      Uri.parse('http://165.227.117.48/games/${widget.gameId}'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['message'] == 'Shot played successfully') {
        bool sunkShip = responseBody['sunk_ship'] ?? false;
        bool gameWon = responseBody['won'] ?? false;
        setState(() {
          shots.add(selectedPosition);
          if (sunkShip) {
            sunk.add(selectedPosition);
            showSnackBar('Ship sunk!');
          } else {
            showSnackBar('No enemy ship hit');
          }
          if (gameWon) {
            showGameOverDialog();
          }
        });
      }
    } else if (response.statusCode == 400) {
      showSnackBar('Shot already played');
    }
    fetchGameDetails();
  }

  Future<void> showGameOverDialog() async {
    String dialogTitle = 'Game over';
    String dialogMessage = 'You won!';

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(dialogTitle),
              content: Text(dialogMessage),
              actions: <Widget>[
                TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }
}
