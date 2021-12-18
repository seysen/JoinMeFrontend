class User {
  int id;
  String name;
  String surname;
  String jwt;

  User({this.id, this.name, this.surname, this.jwt});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        id: int.parse(responseData['userid']) as int,
        name: responseData['name'] as String,
        surname: responseData['surname'] as String,
        jwt: responseData['token'] as String,
    );
  }
}
