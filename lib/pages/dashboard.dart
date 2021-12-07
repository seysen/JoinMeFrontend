import 'package:flutter/material.dart';
import 'package:my_f_app/domain/user.dart';
import 'package:my_f_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashBoardState();
  }
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    final createEventButton = TextButton(
      onPressed: () {
            Navigator.pushNamed(context, '/events');
      },
      child: Text(
        'New event',
        style: (TextStyle(color: Color(0xFF0069C0))),
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100,),
          Center(child: Text(user.id.toString()),),
          SizedBox(height: 10,),
          Center(child: Text(user.jwt.toString()),),
          SizedBox(height: 10,),
          createEventButton,
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
