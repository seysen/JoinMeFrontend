import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

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

  var _events = <Event>[];
  List<Event> get events => _events;

  Status _createdStatus = Status.NotCreated;
  Status get createdStatus => _createdStatus;

  void setEvent(Event event) {
    _event = event;
    notifyListeners();
  }

  void setEvents(var events) {
    _events = events;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getAvatarLinkFromAWS(File imageFile) async {
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var request = new http.MultipartRequest("POST", Uri.parse(ApiUrl.loadImage));

    var multipartFile = new http.MultipartFile('image', stream, length, filename: basename(imageFile.path));

    request.files.add(multipartFile);
    final response = await request.send();
    final answer = await http.Response.fromStream(response);

    var result;
    if (answer.statusCode == 200) {
      result = {
        'status': true,
        'message': 'Image uploaded successfully',
        'data': answer.body
      };
    } else {
      result = {
        'status': false,
        'message': 'Image did not uploaded',
        'data': answer.body
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> create(String eventName, String description, String linkAva, int creatorID, String eventDate) async {

    final Map<String, dynamic> creationData = {
        'name' : eventName,
        'description' : description,
        'link_ava' : linkAva,
        'creator_id' : creatorID,
        'date' : eventDate + "T00:00:00Z"
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