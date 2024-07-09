import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/controllers/auth_controller.dart';
import 'package:tic_tac_toe/src/dialogs/waiting_dialog.dart';

class HomeScreen extends StatelessWidget {
  static const String route = '/home';
  static const String path = "/home";
  static const String name = "Home Screen";

  const HomeScreen({super.key});

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
          Positioned(
            top: 40,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                WaitingDialog.show(context, future: AuthController.I.logout());
              },
              child: const Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }
}
