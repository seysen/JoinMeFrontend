import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_f_app/domain/event.dart';
import '../util/app_url.dart';

enum Status {
  NotCreated,
  Creating,
  Created,
  Finished,
  Deleting,
  Deleted
}

class EventProvider with ChangeNotifier {
  Event _event = Event();
  Event get event => _event;

  Status _createdStatus = Status.NotCreated;
  Status get createdStatus => _createdStatus;

  void setEvent(Event event) {
    _event = event;
    notifyListeners();
  }

  Future<Map<String, dynamic>> create(String eventName, String description, String linkAva, int creatorID) async {

    final Map<String, dynamic> creationData = {
        'name' : eventName,
        'description' : description,
        'link_ava' : linkAva,
        'creator_id' : creatorID
    };

    _createdStatus = Status.Creating;
    notifyListeners();

    return await post(
      Uri.parse(ApiUrl.events),
      body: json.encode(creationData),
      headers: {'Content-Type': 'application/json'})
        .timeout(const Duration(seconds: 3))
        .then(onValue)
        .catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    if (response.statusCode == 200) {
      result = {
        'status': true,
        'message': 'Event created successfully',
        'data': response.body
      };
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      result = {
        'status': false,
        'message': 'Event creation failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("The error is $error.detail");
    return {
      'status': false,
      'message': 'Unsuccessful Request',
      'data': error
    };
  }
}