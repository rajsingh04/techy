import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:techy/models/message_model.dart';
import 'package:techy/utils/constant.dart';

class MessageController {
  final _storage = FlutterSecureStorage();
  fetchMessages(String conversationId) async {
    String token = await _storage.read(key: 'token') ?? '';
    final res = await http.get(
      Uri.parse('$uri/message/$conversationId'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );
    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);
      List<MessageModel> messages = data
          .map((json) => MessageModel.fromJson(json))
          .toList();
      return messages;
    } else {
      throw Exception("Failed to fetch messages");
    }
  }
}
