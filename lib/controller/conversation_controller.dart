import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:techy/models/conversation_model.dart';
import 'package:techy/utils/constant.dart';

class ConversationController {
  final _storage = FlutterSecureStorage();

  fetchConversation() async {
    String token = await _storage.read(key: 'token') ?? '';
    final res = await http.get(
      Uri.parse('$uri/conversation'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);

      List<ConversationModel> chat = data
          .map((json) => ConversationModel.fromJson(json))
          .toList();

      return chat;
    } else {
      throw Exception('Failed to fetch conversations');
    }
  }

  addConversation({required String contactId}) async {
    String token = await _storage.read(key: 'token') ?? '';
    final res = await http.post(
      Uri.parse('$uri/conversation'),
      body: {"contactId": contactId},
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );
    return jsonDecode(res.body);
  }
}
