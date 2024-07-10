import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final int id;
  final int senderId;
  final String content;
  final DateTime createdAt; // Assuming this is a timestamp field from Firestore

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  // Factory constructor to easily create a Message from a Map
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      content: json['content'],
      createdAt: (json['timeStamp'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'content': content,
      'createdAt':
          Timestamp.fromDate(createdAt), // Convert DateTime to Timestamp
    };
  }
}
