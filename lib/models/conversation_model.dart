import 'package:intl/intl.dart';

class ConversationModel {
  final String id;
  final String participantName;
  final String lastMessage;
  final String lastMessageTime;
  final String receiverId;
  final String senderId;

  ConversationModel({
    required this.id,
    required this.participantName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.receiverId,
    required this.senderId,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    String time = " ";
    if (json["lastMessage"].isEmpty) {
      json['lastMessage'].add({"content": " "});
      json["lastMessage"].add({"updatedAt": DateTime.now()});
    } else {
      DateTime dateTime = DateTime.parse(
        json["lastMessage"][0]["updatedAt"],
      ).toLocal();
      time = DateFormat(" dd MMMM HH:mm aa").format(dateTime);
    }

    return ConversationModel(
      id: json['_id'] ?? ' ',
      senderId: json['participant_one'] ?? ' ',
      receiverId: json['participant_two'] ?? ' ',
      participantName: json['participant_name'][0]['username'] ?? ' ',
      lastMessage: json["lastMessage"][0]["content"] ?? ' ',
      lastMessageTime: time,
    );
  }
}
