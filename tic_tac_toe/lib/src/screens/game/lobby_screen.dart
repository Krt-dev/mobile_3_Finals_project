import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/controllers/auth_controller.dart';
import 'package:tic_tac_toe/src/dialogs/waiting_dialog.dart';
import 'package:tic_tac_toe/src/routing/router.dart';
import 'package:intl/intl.dart';
import 'package:tic_tac_toe/src/screens/game/game_screen.dart';
import 'package:tic_tac_toe/src/services/game_board_services.dart';
import 'package:tic_tac_toe/src/models/game_model.dart';

class LobbyScreen extends StatefulWidget {
  static const String route = "/lobbyScreen";
  static const String path = "/lobbyScreen";
  static const String name = "lobby Screen";
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late TextEditingController gameCode;
  late TextEditingController gameSessions;
  bool obfuscate = true;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    gameCode = TextEditingController();
    gameSessions = TextEditingController(text: formattedDate);
  }

  @override
  void dispose() {
    gameCode.dispose();
    super.dispose();
  }

  Future<void> createGameSession() async {
    final gameCodeText = gameCode.text.trim();
    final gameSessionText = gameSessions.text.trim();
    if (gameCodeText.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a game code')),
        );
      }
      return;
    }

    try {
      // para debug rani
      print("Creating game session with game code: $gameCodeText");
      print("Game session text: $gameSessionText");
      print("Current user ID: ${AuthController.I.currentUser?.uid}");

      // await FirebaseFirestore.instance
      //     .collection('Games')
      //     .doc(gameSessionText)
      //     .collection('game')
      //     .add({
      //   'id': gameCodeText,
      //   'createdAt': Timestamp.now(),
      //   //'playerX': AuthController.I.currentUser!.uid,
      //   'board': "Temporary board",
      //   //'currentTurn': AuthController.I.currentUser!.uid,
      //   'gameState': "waiting",
      //   'winner': "winner",
      // });

      await _firestoreService.createGame(
          gameCodeText, AuthController.I.currentUser!.uid);

      if (mounted) {
        Navigator.pushNamed(context, '/gameScreen', arguments: gameCodeText);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create game session: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tictacBG.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, -0.3),
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 33, 243, 114)),
              ),
              child: const Text(
                "JOIN GAME",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, -0.1),
            child: ElevatedButton(
              onPressed: () {
                createGameSession();
                GlobalRouter.I.router.go(
                    "${GameScreen.route}/${gameCode.text.trim()}/${AuthController.I.currentUser?.uid}");
                print(
                    "gamePlayerLobby ${AuthController.I.currentUser?.uid}/ngameID:${gameCode.text.trim()}");
                print("\n\n");
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 72, 33, 243)),
              ),
              child: const Text(
                "CREATE GAME",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Align(
              alignment: const Alignment(0.0, -.5),
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 40, right: 16, bottom: 230, left: 16),
                  child: TextFormField(
                    controller: gameCode,
                    decoration: InputDecoration(
                      labelText: "Enter Game Code",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                  )))
        ],
      ),
    );
  }
}
