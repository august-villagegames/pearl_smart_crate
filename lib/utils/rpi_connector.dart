import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

String serverUrl =
    '10.0.0.69'; //find out how to get to specific process/folder running on the ngrok tunnel

// create function that sends JSON to ip
Future<StreamedResponse> sendRequest(Request request) async {
  var client = Client();
  try {
    return await client.send(request);
  } catch (e) {
    if (e is ClientException) {
      throw Exception('Failed to send request: ${e.message}');
    }
    throw Exception(e);
  } finally {
    client.close();
  }
}

//TODO: try this with ios or simulator instead of chrome
void encodeJsonPushAll(Map<String, bool> weekdays, TimeOfDay time) async {
  Request request = Request('POST', Uri.http(serverUrl));
  request.headers['Content-Type'] = 'application/json';
  request.body = json.encode([
    weekdays,
    {'time': "${time.hour}:${time.minute}"}
  ]);
  print('headers: ${request.headers}');
  print('body: ${request.body}');
  print('Url: ${request.url}');
  print('encoding: ${request.encoding}');
  print('method: ${request.method}');
  sendRequest(request);
}

void openCrateRequest() async {
  Request request = Request('POST', Uri.http('$serverUrl/open'));
  request.headers['Content-Type'] = 'application/json';
  sendRequest(request);
}
