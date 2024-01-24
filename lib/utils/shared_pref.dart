import 'package:flutter/material.dart';
import 'package:pearl_smart_crate/classes/is_checked.dart';
import 'package:pearl_smart_crate/utils/constants.dart';
import 'package:pearl_smart_crate/utils/rpi_connector.dart';
import 'package:shared_preferences/shared_preferences.dart';

// create load for all values
Future<DaysAndTimes> loadAllPreferences() async {
  Map<String, bool> _weekdaysNew = {for (var item in daysOfWeek) item: false};

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // get time
  final int? hour = prefs.getInt('hour');
  final int? minute = prefs.getInt('minute');

  //get weekdays
  for (var day in daysOfWeek) {
    _weekdaysNew[day] = (prefs.getBool(day) ?? false);
  }

  final weekdays = _weekdaysNew;

  if (hour != null && minute != null) {
    // sends this to RPI connector
    try {
      encodeJsonPushAll(weekdays, TimeOfDay(hour: hour, minute: minute));
    } catch (e) {
      throw Exception('Exception: $e');
    }
    final days = weekdays;
    final time = TimeOfDay(hour: hour, minute: minute);
    final instance = DaysAndTimes(day: days, time: time);
    return instance;
  } else {
    // sends this to RPI connector
    try {
      encodeJsonPushAll(weekdays, const TimeOfDay(hour: 7, minute: 15));
    } catch (e) {
      throw Exception('Exception: $e');
    }
    final days = weekdays;
    const time = TimeOfDay(hour: 7, minute: 15);
    final instance = DaysAndTimes(day: days, time: time);
    return instance;
  }
}

// create set for all variables

setAllPreferences(Map<String, bool> weekdays, TimeOfDay time) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("hour", time.hour);
  await prefs.setInt("minute", time.minute);

  for (var entry in weekdays.entries) {
    await prefs.setBool(entry.key, entry.value);
  }

  // sends this to RPI connector
  try {
    encodeJsonPushAll(weekdays, time);
  } catch (e) {
    throw Exception('Exception: $e');
  }
}
