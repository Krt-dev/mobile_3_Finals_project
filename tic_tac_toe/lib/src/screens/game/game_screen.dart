import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/routing/router.dart';
import 'package:tic_tac_toe/src/screens/home/home.screen.dart';

class GameScreen extends StatefulWidget {
  static const String route = '/gameScreen';
  static const String path = "/gameScreen";
  static const String name = "gameScreen";
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gaming Screen PlaceHolder"),
        backgroundColor: Colors.blue,
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Text("This is the gaming screen")),
        ],
      ),
    );
  }
}
