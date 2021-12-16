String validateEmail(String value) {
  String _msg;
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'
  );
  if (value.isEmpty) {
    _msg = "Your email address is required";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid email address";
  }
  return _msg;
}

String validateEventDate(String value) {
  String _msg;
  RegExp regex = new RegExp(r'^\d\d\d\d\-\d\d\-\d\d$');

  List<String> date = value.split("-");
  DateTime currentDate = new DateTime.now();
  if (value.isEmpty) {
    _msg = "Please fill date of event";
  } else if (!regex.hasMatch(value)) {
    _msg = "Fill date like YYYY-MM-DD";
  } else if (regex.hasMatch(value) && int.parse(date[0]) < currentDate.year){
    _msg = "Fill current year, please";
  } else if (regex.hasMatch(value) && !currentMonth(int.parse(date[0]), int.parse(date[1]))){
    _msg = "Fill current month, please";
  } else if (regex.hasMatch(value) && !currentDay(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]))){
    _msg = "Fill current day of month, please";
  }
  return _msg;
}

currentMonth(int year, int month) {
  DateTime currentDate = new DateTime.now();
  if (year > currentDate.year && month > 0 && month <= 12) {
    return true;
  } else if (year == currentDate.year && month >= currentDate.month && month <= 12) {
    return true;
  } else {
    return false;
  }
}

currentDay(int year, int month, int day) {
  DateTime currentDate = new DateTime.now();
  if (year > currentDate.year && day > 0 && day <= 31) {
    return true;
  } else if (year == currentDate.year && month > currentDate.month && day > 0 && day <= 31) {
    return true;
  } else if (year == currentDate.year && month == currentDate.month && day > currentDate.day && day <= 31) {
    return true;
  } else {
    return false;
  }
}