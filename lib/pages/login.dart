import 'package:flutter/material.dart';
import 'package:my_f_app/providers/auth_provider.dart';
import 'package:my_f_app/providers/user_provider.dart';
import 'package:my_f_app/util/validators.dart';
import 'package:provider/provider.dart';

import '../domain/user.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();

  String _email, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    var doLogin = () {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
        auth.login(_email, _password);

        successfulMessage.then((response) {
          if (response['status']) {
            User user = response['user'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Failed Login'),
                  content: Text(response.toString()),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        });
      } else {
        print("form is invalid");
      }
    };

    final logo = Image.asset(
      'asset/images/JoinMeLogo.png',
    );

    final emailField = TextFormField(
        autofocus: false,
        validator: validateEmail,
        onSaved: (value) => _email = value,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0),
          hintText: 'email',
        )
    );

    final passwordField = TextFormField(
        autofocus: false,
        obscureText: true,
        validator: (value) => value.isEmpty ? "Please enter password" : null,
        onSaved: (value) => _password = value,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0),
          hintText: 'Password',
        )
    );

    final loginButton = MaterialButton(
      onPressed: doLogin,
      textColor: Colors.white,
      color: Color(0xFF0069C0),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          'Login',
          textAlign: TextAlign.center,
        ),
      ),
      height: 45,
      minWidth: 600,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    final forgotPasswordButton = TextButton(
      onPressed: () {
//            Navigator.pushNamed(context, '/dashboard');
      },
      child: Text(
        'Forgot password',
        style: (TextStyle(color: Color(0xFF0069C0))),
      ),
    );

    final registerButton = TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
      child: Text(
        'Register now',
        style: (TextStyle(color: Color(0xFF0069C0))),
      ),
    );

    return SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(40.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20.0,),
                      logo,
                      SizedBox(height: 20.0,),
                      emailField,
                      SizedBox(height: 10.0,),
                      passwordField,
                      SizedBox(height: 10.0,),
                      auth.loggedInStatus == Status.Authenticating
                          ? loading
                          : loginButton,
                      SizedBox(height: 5.0,),
                      forgotPasswordButton,
                      SizedBox(height: 5.0,),
                      registerButton
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
