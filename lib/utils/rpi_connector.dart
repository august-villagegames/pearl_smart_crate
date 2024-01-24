import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

String serverUrl = 'localhost:8080';

// create function that sends JSON to ip
// Future<StreamedResponse> sendRequest(Request request) async {
//   var client = Client();

//   print('attempting to send request: $request');
//   try {
//     return await client.send(request);
//   } catch (e) {
//     if (e is ClientException) {
//       throw Exception('Failed to send request: ${e.message}');
//     }
//     throw Exception(e);
//   } finally {
//     client.close();
//   }
// }

void encodeJsonPushAll(Map<String, bool> weekdays, TimeOfDay time) async {
  Request request = Request('Post', Uri.http(serverUrl));
  request.headers['Content-Type'] = 'application/json';
  request.body = json.encode([
    weekdays,
    {'time': "${time.hour}:${time.minute}"}
  ]);
  print(request.body.toString());
}
