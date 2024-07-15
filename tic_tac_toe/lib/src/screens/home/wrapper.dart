import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import 'package:tic_tac_toe/src/screens/game/game_screen.dart';
import 'package:tic_tac_toe/src/screens/game/lobby_screen.dart';
import 'package:tic_tac_toe/src/screens/home/home.screen.dart';

import '../../routing/router.dart';

class HomeWrapper extends StatefulWidget {
  final Widget? child;
  const HomeWrapper({super.key, this.child});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int index = 0;

  List<String> routes = [HomeScreen.route, LobbyScreen.route];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child ?? const Placeholder(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;

            GlobalRouter.I.router.go(routes[i]);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.beach_access), label: "Lobby"),
        ],
      ),
    );
  }
}
