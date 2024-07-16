import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tic_tac_toe/src/models/game_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new game session
  Future<void> createGame(String gameId, String playerX) async {
    List<String> initialBoard = List.generate(9, (_) => '');
    Game game = Game(
      id: gameId,
      playerX: playerX,
      playerO: '',
      board: initialBoard,
      currentTurn: playerX,
      gameState: 'waiting',
      winner: null,
    );
    await _db.collection('games').doc(gameId).set(game.toFirestore());
  }

  Future<void> joinGame(String gameId, String playerO) async {
    await _db.collection('games').doc(gameId).update({
      'playerO': playerO,
      'gameState': 'playing',
    });
  }

  Future<bool> doesGameExist(String gameCode) async {
    final doc = await _db.collection('games').doc(gameCode).get();
    return doc.exists;
  }

  // Update the game board
  Future<void> updateGameBoard(
      String gameId, List<String> board, String currentTurn) {
    return _db.collection('games').doc(gameId).update({
      'board': board,
      'currentTurn': currentTurn,
    });
  }

  Stream<Game> getGameStream(String gameId) {
    return _db.collection('games').doc(gameId).snapshots().map((doc) {
      try {
        return Game.fromFirestore(doc);
      } catch (e) {
        print("Failed to deserialize game: $e");
        throw e; // Rethrow or handle as needed
      }
    });
  }

  // Update the winner
  Future<void> updateWinner(String gameId, String winner) {
    return _db.collection('games').doc(gameId).update({
      'winner': winner,
      'gameState': 'finished',
    });
  }

  // Get the game stream
  // Stream<Game> getGameStream(String gameId) {
  //   return _db.collection('games').doc(gameId).snapshots().map((snapshot) {
  //     return Game.fromFirestore(snapshot);
  //   });
  // }
}
