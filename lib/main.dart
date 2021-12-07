import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_f_app/pages/events.dart';
import 'package:my_f_app/providers/event_provider.dart';
import 'package:provider/provider.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/dashboard.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'util/shared_preferences.dart';


void main() {
  runApp(JoinMeApp());
}

class JoinMeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<String> getJwt() => UserPreferences().getJwt();

    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => EventProvider())
    ],
      child: MaterialApp(
        theme: ThemeData(
          //primarySwatch: Colors.blue,
          primaryColor: Colors.blueAccent,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
            primary: Color(0xFF0069C0),
          ),
        ),
        hintColor: Color(0xFF6ec6ff),
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: getJwt(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return CircularProgressIndicator();
            if(snapshot.data != "") {
              var data = snapshot.data;
              var jwt = data.split(".");
              if (jwt.length != 3) {
                return Login();
              } else {
                var decode = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if (DateTime.fromMicrosecondsSinceEpoch(decode["exp"]*1000).isAfter(DateTime.now())) {
                  return DashBoard();
                } else {
                  return Login();
                }
              }
            } else {
              return Login();
            }
          }
        ),
        routes: {
          '/dashboard': (context) => DashBoard(),
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/events': (context) => EventsPage()
        },
      ),
    );
  }
}
