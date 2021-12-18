import 'package:flutter/material.dart';

class JoinMeAppPanels {

  getTopPanel(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);

    var width = _mediaQuery.size.width;

    return Positioned(
      top: 2.0,
      child: Container(
        width: width,
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.manage_search,
                color: Colors.white,
                size: 30,
              ),
              tooltip:
              'Back to swiping',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/events_slider');
              },
            ),
            Text(
              '|',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 40,
                  letterSpacing: 0.5,
                  color: Colors.white),
            ),
            IconButton(
              icon: Icon(
                Icons.question_answer,
                color: Colors.white,
                size: 30,
              ),
              tooltip: 'Chat',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/fake_chat');
              },
            ),
            Text(
              '|',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 40,
                  letterSpacing: 0.5,
                  color: Colors.white),
            ),
            IconButton(
              icon: Icon(
                Icons.image,
                color: Colors.white,
                size: 30,
              ),
              tooltip: 'Gallery',
              onPressed: () {
                //todo сделать заглушку для галереи
              },
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Color(0xFF0069C0),
        ),
      ),
    );
  }

  getBottomPanel(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);

    var width = _mediaQuery.size.width;

    return  Container(
        width: width,
        height: 60,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.content_copy,
                  color: Colors.white,
                  size: 30,
                ),
                tooltip: 'Swipe events',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/events_slider');
                },
              ),
              Text(
                '|',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 40,
                    letterSpacing: 0.5,
                    color: Colors.white),
              ),
              IconButton(
                icon: Icon(
                  Icons.perm_identity,
                  color: Colors.white,
                  size: 30,
                ),
                tooltip: 'Profile',
                onPressed: () {
                  Navigator.pushReplacementNamed(context,
                      '/profile_page'); // !!! сюда вставлять профиль а в профиле кнопка добавить событие
                },
              ),
              Text(
                '|',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 40,
                    letterSpacing: 0.5,
                    color: Colors.white),
              ),
              IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 30,
                ),
                tooltip: 'Messages',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/fake_chat');
                },
              ),
            ],
          )
        ]),
        decoration: BoxDecoration(
          color: Color(0xFF0069C0),
        ),
      );
  }
}