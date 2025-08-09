class ContactModel {
  final String id;
  final String username;
  final String email;
  ContactModel({required this.id, required this.username, required this.email});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['_id'] ?? '',
      username: json['contact_username'] ?? '',
      email: json['contact_details'][0]['email'] ?? "",
    );
  }
}
