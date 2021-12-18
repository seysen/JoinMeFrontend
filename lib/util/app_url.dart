class ApiUrl {
  static const String productionBaseUrl = 'https://remoteadress';
  static const String localBaseUrl = 'http://10.0.2.2:8080';

  static const String baseURL = localBaseUrl;
  static const String login = baseURL + '/login';
  static const String register = baseURL + "/register";

  static const String events = baseURL + "/events";
  static const String joinEvent = baseURL + "/events/join";
  static const String loadImage = baseURL + "/image";

  static const String fakeChat = baseURL + "/fake_chat";

  static const String userEvents = "/events/user";
}
