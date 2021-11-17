import 'package:my_f_app/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
 Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("id", user.id);
    prefs.setString("jwt", user.jwt);

    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt("id");
    String jwt = prefs.getString("jwt");

    return User(
        id: id,
        jwt: jwt
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("name");
    prefs.remove("jwt");
  }

  Future<String> getJwt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("jwt");
    if (jwt == null) return "";
    return jwt;
  }
}
