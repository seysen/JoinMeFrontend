import 'package:flutter/material.dart';
import 'package:my_f_app/domain/user.dart';
import 'package:my_f_app/providers/auth_provider.dart';
import 'package:my_f_app/providers/user_provider.dart';
import 'package:my_f_app/util/validators.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();

  String _name, _surname, _email, _password, _confirmPassword;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    var doRegister = () {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        auth.register(_name, _surname, _email, _password).then((response) {
          if (response['status']) {
            User user = response['data'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/events_slider');
          } else {
            return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Registration Failed'),
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
        return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid form'),
              content: Text('Please Complete the form properly'),
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
    };

    final logo = Image.asset(
      'asset/images/JoinMeLogo.png',
    );

    final nameField = TextFormField(
        autofocus: false,
        onSaved: (value) => _name = value,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          hintText: 'Your name',
        ));

    final surNameField = TextFormField(
        autofocus: false,
        onSaved: (value) => _surname = value,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          hintText: 'Your surname',
        ));

    final emailField = TextFormField(
        autofocus: false,
        validator: validateEmail,
        onSaved: (value) => _email = value,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          hintText: 'email',
        ));

    final passwordField = TextFormField(
        autofocus: false,
        obscureText: true,
        validator: (value) => value.isEmpty ? "Please enter password" : null,
        onSaved: (value) => _password = value,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          hintText: 'Password',
        ));

    final confirmPasswordField = TextFormField(
        autofocus: false,
        obscureText: true,
        validator: (value) => value.isEmpty
            ? "Please enter password"
            : null, //todo validate equals passwordField and confirmPasswordField
        onSaved: (value) => _confirmPassword = value,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          hintText: 'Confirm password',
        ));

    final registerButton = MaterialButton(
      onPressed: doRegister,
      textColor: Colors.white,
      color: Color(0xFF0069C0),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          'Register',
          textAlign: TextAlign.center,
        ),
      ),
      height: 45,
      minWidth: 600,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    final privacyPolicy = Text(
      'By clicking Register, I agree that I have read and accepted the JoinMe Terms of Use and Privacy Policy',
      style: TextStyle(
        color: Color(0xFF0069C0),
      ),
      textAlign: TextAlign.center,
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
                  SizedBox(
                    height: 20.0,
                  ),
                  logo,
                  SizedBox(
                    height: 20.0,
                  ),
                  nameField,
                  SizedBox(
                    height: 10.0,
                  ),
                  surNameField,
                  SizedBox(
                    height: 10.0,
                  ),
                  emailField,
                  SizedBox(
                    height: 10.0,
                  ),
                  passwordField,
                  SizedBox(
                    height: 10.0,
                  ),
                  confirmPasswordField,
                  SizedBox(
                    height: 10.0,
                  ),
                  auth.loggedInStatus == Status.Authenticating
                      ? loading
                      : registerButton,
                  SizedBox(
                    height: 10.0,
                  ),
                  privacyPolicy,
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
