import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:techy/models/user_model.dart';
import 'package:techy/utils/constant.dart';

class AuthController {
  logInUser(String username, String password) async {
    http.Response res = await http.post(
      Uri.parse('$uri/login'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode > 300) {
      return jsonDecode(res.body)["msg"];
    }
    return UserModel.fromJson(jsonDecode(res.body));
  }

  registerUser(String username, String email, String password) async {
    var res = await http.post(
      Uri.parse('$uri/register'),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode > 300) {
      return jsonDecode(res.body)["msg"];
    }
    return UserModel.fromJson(jsonDecode(res.body));
  }
}
