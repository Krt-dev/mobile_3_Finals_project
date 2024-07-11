import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/src/models/game_model.dart';
import 'package:tic_tac_toe/src/services/game_board_services.dart';

class GameScreen extends StatefulWidget {
  static const String route = '/gameScreen';
  static const String path = "/gameScreen";
  static const String name = "game Screen";
  final String gameId;
  final String playerId;

  const GameScreen({required this.gameId, required this.playerId, super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FirestoreService _firestoreService;

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService();
  }

  @override
  Widget build(BuildContext context) {
    var gameId = widget.playerId;
    var playerId = widget.gameId;
    return Scaffold(
      body: StreamBuilder<Game>(
        // stream: _firestoreService.getGameStream(widget.gameId),
        stream: _firestoreService.getGameStream(gameId),

        builder: (context, snapshot) {
          print(snapshot.data?.board);
          print("playerID" + widget.playerId);
          print("gameID" + widget.gameId);
          if (snapshot.hasError) {
            return const Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          if (snapshot.hasData) {
            Game game = snapshot.data!;
            bool isPlayerTurn = game.currentTurn == playerId;

            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/tictacBG.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        int row = index ~/ 3;
                        int col = index % 3;
                        return GestureDetector(
                          onTap: isPlayerTurn && game.board[index] == ''
                              ? () => _makeMove(row, col, game)
                              : null,
                          child: Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: game.board[index] == ''
                                  ? Colors.white
                                  : game.board[index] == 'X'
                                      ? Colors.red
                                      : Colors.blue,
                            ),
                            child: Center(
                              child: Text(
                                game.board[index],
                                style: const TextStyle(fontSize: 48),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (game.winner != null)
                      Text(
                        '${game.winner} wins!',
                        style:
                            const TextStyle(fontSize: 32, color: Colors.green),
                      ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
                child: Column(
              children: [
                CircularProgressIndicator(),
              ],
            ));
          }
        },
      ),
    );
  }

  void _makeMove(int row, int col, Game game) async {
    int index = row * 3 + col;
    List<String> newBoard = List.from(game.board);
    newBoard[index] = game.currentTurn == game.playerX ? 'X' : 'O';

    String? winner = _checkWinner(newBoard);

    await _firestoreService.updateGameBoard(
      game.id,
      newBoard,
      game.currentTurn == game.playerX ? game.playerO : game.playerX,
    );

    if (winner != null) {
      await _firestoreService.updateWinner(game.id, winner);
    }
  }

  // String? _checkWinner(List<List<String>> board) {
  //   for (int i = 0; i < 3; i++) {
  //     if (board[i][0] != '' &&
  //         board[i][0] == board[i][1] &&
  //         board[i][1] == board[i][2]) {
  //       return board[i][0];
  //     }
  //     if (board[0][i] != '' &&
  //         board[0][i] == board[1][i] &&
  //         board[1][i] == board[2][i]) {
  //       return board[0][i];
  //     }
  //   }
  //   if (board[0][0] != '' &&
  //       board[0][0] == board[1][1] &&
  //       board[1][1] == board[2][2]) {
  //     return board[0][0];
  //   }
  //   if (board[0][2] != '' &&
  //       board[0][2] == board[1][1] &&
  //       board[1][1] == board[2][0]) {
  //     return board[0][2];
  //   }
  //   return null;
  // }

  String? _checkWinner(List<String> board) {
    List<List<int>> winningCombinations = [
      [0, 1, 2], // Row 1
      [3, 4, 5], // Row 2
      [6, 7, 8], // Row 3
      [0, 3, 6], // Column 1
      [1, 4, 7], // Column 2
      [2, 5, 8], // Column 3
      [0, 4, 8], // Diagonal
      [2, 4, 6], // Diagonal
    ];

    for (List<int> combination in winningCombinations) {
      if (board[combination[0]] != '' &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[1]] == board[combination[2]]) {
        return board[combination[0]];
      }
    }

    return null;
  }
}
