// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaysAndTimes {
  Map<String, bool>? day;
  TimeOfDay? time;

  DaysAndTimes({
    required this.day,
    required this.time,
  });

  String intToWeekday(int day) {
    if (day < 1 || day > 7) {
      throw "Invalid day int";
    }

    DateTime tempDate = DateTime(2024, 1, 1).add(Duration(days: day - 1));

    // convert int to day of week
    return DateFormat('EEEE').format(tempDate);
  }
}
