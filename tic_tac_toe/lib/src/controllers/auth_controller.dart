import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tic_tac_toe/src/enum/enum.dart';
import 'package:tic_tac_toe/src/models/message_model.dart';

class AuthController with ChangeNotifier {
  // Static method to initialize the singleton in GetIt
  static void initialize() {
    GetIt.instance.registerSingleton<AuthController>(AuthController());
  }

  // Static getter to access the instance through GetIt
  static AuthController get instance => GetIt.instance<AuthController>();

  static AuthController get I => GetIt.instance<AuthController>();

  User? user;

  AuthState state = AuthState.unauthenticated;

  // SimulatedAPI api = SimulatedAPI();
  late StreamSubscription<User?> currentAuthedUser;

  listen() {
    currentAuthedUser =
        FirebaseAuth.instance.authStateChanges().listen(handleUserChanges);
  }

  void handleUserChanges(User? user) {
    if (user == null) {
      state = AuthState.unauthenticated;
    } else {
      state = AuthState.authenticated;
    }
    notifyListeners();
  }

  register(String email, String password) async {
    UserCredential? userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    user = userCredential.user;
    notifyListeners();
  }

  login(String userName, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: userName, password: password);
    user = userCredential.user;
    notifyListeners();
  }

  ///write code to log out the user and add it to the home page.
  logout() async {
    user = null;
    notifyListeners();
    return await FirebaseAuth.instance.signOut();
  }

  ///must be called in main before runApp
  ///
  loadSession() async {
    listen();
    User? user = FirebaseAuth.instance.currentUser;
    handleUserChanges(user);
  }

  //message controller testing in auth

  Stream<QuerySnapshot<Object?>> getGameMessages() {
    return FirebaseFirestore.instance
        .collection('message')
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  ///https://pub.dev/packages/flutter_secure_storage or any caching dependency of your choice like localstorage, hive, or a db
}

// class SimulatedAPI {
//   Map<String, String> users = {"testUser": "12345678ABCabc!"};

//   Future<bool> login(String userName, String password) async {
//     await Future.delayed(const Duration(seconds: 4));
//     if (users[userName] == null) throw Exception("User does not exist");
//     if (users[userName] != password)
//       throw Exception("Password does not match!");
//     return users[userName] == password;
//   }
// }
