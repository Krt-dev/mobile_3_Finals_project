import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/controllers/auth_controller.dart';
import 'package:tic_tac_toe/src/dialogs/waiting_dialog.dart';
import 'package:tic_tac_toe/src/routing/router.dart';

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
  bool obfuscate = true;

  @override
  void initState() {
    super.initState();
    gameCode = TextEditingController();
  }

  @override
  void dispose() {
    gameCode.dispose();
    super.dispose();
  }

  Future<void> createGameSession() async {
    final gameCodeText = gameCode.text.trim();
    if (gameCodeText.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a game code')),
        );
      }
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('game_sessions')
          .doc(gameCodeText)
          .set({
        'gameCode': gameCodeText,
        'createdAt': Timestamp.now(),
        'players': [],
      });

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
              onPressed: createGameSession,
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
