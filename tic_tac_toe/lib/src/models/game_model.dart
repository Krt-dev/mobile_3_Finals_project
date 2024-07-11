import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  final String id;
  final String playerX;
  final String playerO;
  final List<String> board;
  late final String currentTurn;
  final String gameState;
  late final String? winner;

  Game({
    required this.id,
    required this.playerX,
    required this.playerO,
    required this.board,
    required this.currentTurn,
    required this.gameState,
    this.winner,
  });

  // Factory constructor to create a Game from a Firestore document
  factory Game.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Game(
      id: doc.id,
      playerX: data['playerX'],
      playerO: data['playerO'],
      board:
          List<String>.from(data['board'].map((row) => List<String>.from(row))),
      currentTurn: data['currentTurn'],
      gameState: data['gameState'],
      winner: data['winner'],
    );
  }

  // Method to convert a Game to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'playerX': playerX,
      'playerO': playerO,
      'board': board,
      'currentTurn': currentTurn,
      'gameState': gameState,
      'winner': winner,
    };
  }
}
