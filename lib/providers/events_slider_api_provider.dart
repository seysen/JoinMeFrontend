import 'dart:convert';

import 'package:http/http.dart';
import 'package:my_f_app/domain/event_slider.dart';
import 'package:http/http.dart' as http;
import 'package:my_f_app/util/app_url.dart';

class EventsSliderApiProvider {
  final _client = http.Client();

  Future<List<EventSlider>> getEvents() async {
    final response = await http.get(Uri.parse(ApiUrl
        .events)); //  Future<List<Event>> getEvents({int num = 10}) 'https://randomuser.me/api/?results=$num')
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
      print("Nothing");
      return [];
    }
  }

  Future<int> joinEvent(int userId, int eventId) async {
    final Map<String, dynamic> request = {
      'user_id': userId,
      'event_id': eventId
    };

    final response = await post(Uri.parse(ApiUrl.joinEvent),
        body: json.encode(request),
        headers: {'Content-Type': 'application/json'});

    return response.statusCode;
  }
}
