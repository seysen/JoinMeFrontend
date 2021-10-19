class User {
  int id;
  String jwt;

  User({this.id, this.jwt});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        id: responseData['userid'] as int,
        jwt: responseData['token'] as String,
    );
  }
}
