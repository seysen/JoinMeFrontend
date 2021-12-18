import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_f_app/domain/user.dart';
import '../util/shared_preferences.dart';
import '../util/app_url.dart';


enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
        'email': email,
        'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    var response = await post(
      Uri.parse(ApiUrl.login),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},)
        .timeout(const Duration(seconds: 3));

    _loggedInStatus = Status.NotLoggedIn;
    notifyListeners();

    if (response.statusCode == 200) {

      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      var authUser = User.fromJson(responseBody);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> register(String name, String surname, String email, String password) async {

    final Map<String, dynamic> registrationData = {
        'name': name,
        'surname': surname,
        'email': email,
        'password': password
    };

    _registeredInStatus = Status.Registering;
    notifyListeners();

    return await post(
        Uri.parse(ApiUrl.register),
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'})
        .timeout(const Duration(seconds: 3))
        .then(onValue)
        .catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
     var result;
     final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 201) {
      var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      var authUser = User.fromJson(responseBody);
      UserPreferences().saveUser(authUser);

      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }
    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
