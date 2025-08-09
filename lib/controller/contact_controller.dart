import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:techy/models/contact_model.dart';
import 'package:techy/utils/constant.dart';

class ContactController {
  final _storage = FlutterSecureStorage();
  fetchContacts() async {
    String token = await _storage.read(key: "token") ?? '';
    final res = await http.get(
      Uri.parse("$uri/contact"),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );
    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);

      return data.map((json) => ContactModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch messages');
    }
  }

  addContact(String contactUsername) async {
    String token = await _storage.read(key: "token") ?? '';
    final res = await http.post(
      Uri.parse("$uri/contact"),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({'contact_username': contactUsername}),
    );

    if (res.statusCode != 201) {
      throw Exception("Failed to add contact");
    }
  }
}
