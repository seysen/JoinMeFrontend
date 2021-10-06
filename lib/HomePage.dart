import 'package:flutter/material.dart';

import 'http_service.dart';

class HomePage extends StatelessWidget  {

  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
          future: httpService.getHello(),
          builder:(BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.toString(), style: TextStyle(color: Colors.black, fontSize: 25));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
      )
      );

  }
}
