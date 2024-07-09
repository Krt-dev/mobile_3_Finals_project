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
  late TextEditingController gameCode = TextEditingController();
  bool obfuscate = true;

  @override
  void initState() {
    super.initState();
    gameCode = TextEditingController();
  }

  @override
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
              onPressed: () {},
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
