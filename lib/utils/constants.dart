/*
This file can store all your constants, 
like color schemes, text styles, or any
 other reusable constants. It's like the 
 style guide of your coffee shop, ensuring 
 everything looks consistent.
*/

import 'package:intl/intl.dart';

String intToWeekday(int day) {
  if (day < 1 || day > 7) {
    throw "Invalid day int";
  }

  DateTime tempDate = DateTime(2024, 1, 1).add(Duration(days: day - 1));

  // convert int to day of week
  return DateFormat('EEEE').format(tempDate);
}

List<String> daysOfWeek = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

int weekdayToInt(String day) {
  // try to match from map. if not found, throe error
  int index = daysOfWeek.indexWhere((item) => item == day);

  return index != -1 ? index : throw "day not found";
}

Map<String, bool> isChecked = {};
