import 'dart:convert';

import 'package:my_f_app/domain/event_slider.dart';
import 'package:http/http.dart' as http;

class EventsSliderApiProvider {
  final _client = http.Client();

  Future<List<EventSlider>> getEvents() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/events')); //  Future<List<Event>> getEvents({int num = 10}) 'https://randomuser.me/api/?results=$num')
    if (response.statusCode == 200) {
      final events = <EventSlider>[];

      //  print(jsonDecode(utf8.decode(response.bodyBytes)));

      final parsedResults = jsonDecode(
          utf8.decode(response.bodyBytes)); // jsonDecode((response.body));

      (parsedResults["result"] as List).forEach((parsedJson) {
        events.add(EventSlider.fromJson(parsedJson));
      });
      // events.forEach((element) => print(element.name));
      return events;
    } else {
      print("Nah");
      return [];
    }
  }
}
