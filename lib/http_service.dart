import 'dart:convert';
import 'package:http/http.dart';

class HttpService {
  static const url = "http://10.0.2.2:8080/hello";

  Future<String> getHello() async {
    Response response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      String result = jsonDecode(json.encode(response.body));
      print(result); // check in console
      return result;
    } else {
      throw "Unable to get hello.";
    }
  }
}