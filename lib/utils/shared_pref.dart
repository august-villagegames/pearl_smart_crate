import 'package:flutter/material.dart';
import 'package:pearl_smart_crate/utils/constants.dart';
import 'package:pearl_smart_crate/utils/rpi_connector.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, bool>> loadWeekdayPreferences() async {
  //creates map with bool false for everything
  Map<String, bool> weekdaysNew = {for (var item in daysOfWeek) item: false};

  SharedPreferences prefs = await SharedPreferences.getInstance();

  for (var day in daysOfWeek) {
    weekdaysNew[day] = (prefs.getBool(day) ?? false);
  }
  print("weekdays loaded");
  return weekdaysNew;
  //do same for time settings
}

Future<TimeOfDay> loadTimePreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final int? hour = prefs.getInt('hour');
  final int? minute = prefs.getInt('minute');

  if (hour != null && minute != null) {
    print('time loaded');
    return TimeOfDay(hour: hour, minute: minute);
  } else {
    throw Exception("no time found in sharedprefences");
  }
}

setWeekdayPreferences(String day, bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool(day, value);

  encodeJsonPushWeekday(day, value);

  print('weekdays set');
}

setTimePreferences(TimeOfDay time) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("hour", time.hour);
  await prefs.setInt("minute", time.minute);
  print('time set');
}
