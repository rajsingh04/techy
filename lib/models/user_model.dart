class UserModel {
  final String id;
  final String username;
  final String email;
  final String token;
  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['_id'] ?? '',
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    token: json['token'] ?? '',
  );
}
