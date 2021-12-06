//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:my_f_app/service/event_browse_service.dart';
import 'package:my_f_app/domain/event_slider.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EventCard extends StatelessWidget {
  final EventSlider event;
  final int index;

  const EventCard(
      {this.event, this.index, Key key}) // key можно в конструкторе виджета,
      // Keys сохраняют состояние при перемещении виджетов в дереве виджетов
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Swipable(
        verticalSwipe: false,
        onSwipeLeft: (finalPosition) {
          EventBrowseService().swipedLeft(index, event);
        },
        onSwipeRight: (finalPosition) {
          Navigator.pushReplacementNamed(context, '/dashboard');
          // ЗАМЕНИТЬ ПЕРЕХОДОМ В ЗАГЛУШКУ СООБЩЕНИЯ
        },
        onPositionChanged: (details) {},
        onSwipeStart: (details) {},
        onSwipeCancel: (position, details) {},
        onSwipeEnd: (position, details) {},
        child: Card(
          elevation: 2,
          child: LayoutBuilder(builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight * 0.87 -
                76; // 0.13 на нижнюю панель + 76 на слайдер

            return Container(
              height: maxHeight,
              width: maxWidth,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(event.ava,
                        width: maxWidth,
                        height: maxHeight,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter),
                  )
                ],
              ),
            );
          }),
        ));
  }
}
