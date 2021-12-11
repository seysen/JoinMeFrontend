import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_f_app/domain/event_card.dart';
import 'package:my_f_app/domain/event_slider.dart';
import 'package:my_f_app/service/event_browse_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EventsSliderPage extends StatefulWidget {
  EventsSliderPage({Key key}) : super(key: key) {
    init();
  }

  void init() async {
    EventBrowseService().browseEvents();
  }

  @override
  _EventsSliderPageState createState() => _EventsSliderPageState();
}

class _EventsSliderPageState extends State<EventsSliderPage> {
  var showUpperEventPanel = false;

  _EventsSliderPageState();

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);

    var height = _mediaQuery.size.height -
        kBottomNavigationBarHeight -
        kToolbarHeight +
        30;

    var width = _mediaQuery.size.width;

    var currentEvent;

    return Scaffold(
      appBar: AppBar(
        title: Text("JoinMe"),
        backgroundColor: Color(0xFF0069C0),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<List<EventSlider>>(
            //  прослушивает изменения на своем
            // соответствующем объекте. И запускают новую сборку, когда они получают уведомление
            // о новом значении
            // Future не может прослушивать изменение переменной.
            // Это одноразовый ответ. Вместо этого вам нужно будет использовать Stream
            stream: EventBrowseService().eventsBrowsed,
            // BehaviorSubject = левая сторона конвейера туда кладем
            //С BehaviourSubject каждый новый подписчик получит сперва последнее принятое значение:
            builder: (context, snapshot) {
              // Snapshot is the result of the Future/Stream you are listening to in your FutureBuilder
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              // если эвентов нет
              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data.length == 0) {
                return Column(children: [
                  Image.network(
                      "https://litvinovaprogrammersblog-storage.s3.us-east-2.amazonaws.com/f106bffa-23d1-4d9a-8dc8-8ccf9de65d8b_663e92838199241859d9d0f132352061.jpg",
                      width: width,
                      height: height * 0.7,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter),
                  Container(
                      width: width,
                      height: 50,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(20.0),
                      child: Text(
                          "No events yet, try again later or be the first to add event",
                          style: TextStyle(fontSize: 20))),
                  Container(
                    width: width * 0.7,
                    height: 50,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          child: Text('ADD',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.white)),
                          onPressed: () {
                            // returns from gallery or dialog to swiping events
                            Navigator.pushReplacementNamed(
                                context, '/dashboard');
                          },
                        ),
                        Text(
                          ' |',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 40,
                              color: Colors.white),
                        ),
                        TextButton(
                          child: Text('recheck',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.white)),
                          onPressed: () {
                            // returns from gallery or dialog to swiping events
                            Navigator.pushReplacementNamed(
                                context, '/events_slider');
                          },
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF0069C0),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ]);
              } // no more events, start browse from the beginning

              final events = snapshot.data ??
                  <EventSlider>[]; // The ?? double question mark operator means "if null"
              return Container(
                // padding: const EdgeInsets.fromLTRB(0.1, 0.1, 0.1, 0.1),
                width: width,
                height: height,
                child: Stack(alignment: Alignment.topCenter, children: <Widget>[
                  // creation of EventCard
                  Stack(
                    fit: StackFit.expand,
                    alignment: AlignmentDirectional.center,
                    children: events.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final event = entry.value;
                        return currentEvent =
                            EventCard(index: index, event: event);
                      },
                    ).toList(),
                  ),
                  // верхняя панель навигации по эвенту
                  if (showUpperEventPanel)
                    Positioned(
                      top: 10.0,
                      child: Container(
                        width: width,
                        height: height * 0.10,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.manage_search,
                                color: Colors.white,
                                size: 40,
                              ),
                              tooltip:
                                  'Back to swiping', // ??? дублируется уже есть
                              onPressed: () {
                                // returns from gallery or dialog to swiping events
                                Navigator.pushReplacementNamed(
                                    context, '/events_slider');
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
                                size: 40,
                              ),
                              tooltip: 'Chat',
                              onPressed: () {
                                Navigator.pushReplacementNamed(context,
                                    '/dashboard'); // go to Dialog ЗАМЕНИТЬ ПЕРЕХОДОМ В ЗАГЛУШКУ СООБЩЕНИЯ
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
                                size: 40,
                              ),
                              tooltip: 'Gallery',
                              onPressed: () {
                                // go to event Gallery ЗАГЛУШКА ВСТАВИТЬ
                              },
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF0069C0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  // слайдинг панель с инф собятия
                  SlidingUpPanel(
                    color: Color(0xFF0069C0),
                    maxHeight: 250,
                    minHeight: 76,
                    parallaxEnabled: true,
                    parallaxOffset: .5,
                    panelBuilder: (sc) => _panel(sc, context, currentEvent),
                    // footer: _bottomPanel(width, height),
                    margin: EdgeInsets.only(bottom: height * 0.1),
                    onPanelOpened: () => setState(() {
                      showUpperEventPanel = true;
                    }),
                    onPanelClosed: () => setState(() {
                      showUpperEventPanel = false;
                    }),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),
                  ),
                  // нижняя панель навигации по приложению
                  Positioned(
                    bottom: 2.0,
                    child: Container(
                      width: width,
                      height: height * 0.10,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                      child: Column(children: [
                        Container(width: width, height: 1, color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.content_copy,
                                color: Colors.white,
                                size: 35,
                              ),
                              tooltip: 'Swipe events',
                              onPressed: () {
                                // go to swiping events
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
                                size: 35,
                              ),
                              tooltip: 'Profile',
                              onPressed: () {
                                Navigator.pushReplacementNamed(context,
                                    '/dashboard'); // !!! сюда вставлять профиль а в профиле кнопка добавить событие
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
                                size: 35,
                              ),
                              tooltip: 'Messages',
                              onPressed: () {
                                // go to messages
                              },
                            ),
                          ],
                        )
                      ]),
                      decoration: BoxDecoration(
                        color: Color(0xFF0069C0),
                      ),
                    ),
                  )
                ]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _panel(
      ScrollController sc, BuildContext context, EventCard currentEvent) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
            controller: sc,
            padding:
                const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
            children: <Widget>[
              // название дата и значки
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${currentEvent.event.name}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: Colors.white),
                    ),
                    Text(
                      DateFormat("yyyy-MM-dd HH:mm")
                          .format(DateTime.parse('${currentEvent.event.date}')),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: Colors.white),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          TextSpan(
                            text: '${currentEvent.event.likes}   ' + '|  ',
                          ),
                          WidgetSpan(
                            child: Icon(
                              Icons.people_outline,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          TextSpan(
                            text: '${currentEvent.event.users}',
                          ),
                        ],
                      ),
                    )
                  ]),
              //текст описания
              Container(
                padding: const EdgeInsets.only(
                    left: 10, top: 10, right: 10, bottom: 10),
                child: Text(
                  '${currentEvent.event.description}',
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.5,
                      color: Colors.white),
                ),
              )
            ]));
  }
}
