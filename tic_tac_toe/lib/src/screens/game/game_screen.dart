import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/controllers/auth_controller.dart';
import 'package:tic_tac_toe/src/models/game_model.dart';
import 'package:tic_tac_toe/src/models/message_model.dart';
import 'package:tic_tac_toe/src/services/game_board_services.dart';
import 'package:uuid/uuid.dart';

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
    return Scaffold(
      body: StreamBuilder<Game>(
        // stream: _firestoreService.getGameStream(widget.gameId),
        stream: _firestoreService.getGameStream(widget.gameId),

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
            bool isPlayerTurn = game.currentTurn == widget.playerId;

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
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 400,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Expanded(
                                child: Container(
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('games')
                                      .doc(widget.gameId)
                                      .collection('chats')
                                      .orderBy('createdAt', descending: false)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.active) {
                                      print(widget.gameId);

                                      if (snapshot.hasData) {
                                        QuerySnapshot dataSnapShot =
                                            snapshot.data as QuerySnapshot;
                                        print(dataSnapShot.docs.length);
                                        return ListView.builder(
                                            itemCount: dataSnapShot.docs.length,
                                            itemBuilder: (context, index) {
                                              Message curmessage =
                                                  Message.fromJson(dataSnapShot
                                                          .docs[index]
                                                          .data()
                                                      as Map<String, dynamic>);

                                              print("currentUSer");
                                              print(AuthController
                                                  .I.currentUser?.uid);
                                              print("sender");
                                              print("print: " +
                                                  curmessage.senderID);
                                              return Row(
                                                mainAxisAlignment: (curmessage
                                                            .senderID
                                                            .toString() ==
                                                        AuthController
                                                            .I.currentUser?.uid)
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 6,
                                                        horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color:
                                                            Color(0xFF00D2FF)),
                                                    child: Text(
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                        curmessage.content
                                                            .toString()),
                                                  ),
                                                ],
                                              );
                                            });
                                      } else if (snapshot.hasError) {
                                        return const Center(
                                          child: Text("Snapshot Error"),
                                        );
                                      } else {
                                        return const Center(
                                          child: Text("Error occured"),
                                        );
                                      }
                                    } else {
                                      return const Center(
                                        child: Text(
                                            "Snapshot Connection state not active"),
                                      );
                                    }
                                  }),
                            )),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Row(
                                children: [
                                  Flexible(
                                      child: TextField(
                                    controller: messageController,
                                    decoration: InputDecoration(
                                        hintText: "Enter Chat",
                                        border: InputBorder.none),
                                  )),
                                  IconButton(
                                      onPressed: sendMessage,
                                      icon: const Icon(Icons.send))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
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

  final TextEditingController messageController = TextEditingController();
  var uuid = Uuid();
  String? Sender = AuthController.I.currentUser?.uid;
  void sendMessage() {
    String msg = messageController.text.trim();

    if (msg != '') {
      Message newmessage = Message(
          id: uuid.v1(),
          senderID: Sender.toString(),
          content: msg,
          createdAt: DateTime.now());
      FirebaseFirestore.instance
          .collection("games")
          .doc(widget.gameId)
          .collection("chats")
          .doc(newmessage.id)
          .set(newmessage.toJson());
    }

    messageController.clear();
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
