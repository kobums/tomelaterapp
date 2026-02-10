class User {
  final int id;
  final String email;
  final String nickname;

  User({required this.id, required this.email, required this.nickname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
    );
  }
}
