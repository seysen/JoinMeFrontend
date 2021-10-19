import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_f_app/domain/user.dart';
import 'package:my_f_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  final User user;

  const Welcome({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).setUser(user);
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Image.asset(
            'asset/images/JoinMeLogo.png',
          ),
        )
      ),
    );
  }
}
