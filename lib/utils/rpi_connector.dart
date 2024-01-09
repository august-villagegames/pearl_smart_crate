import 'dart:convert';
import 'package:http/http.dart';

String serverUrl = 'http://localhost:8080';

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

// create JSCON encoder
void encodeJsonPushWeekday(String day, bool value) async {
  Request request = Request('POST', Uri.parse('$serverUrl/addWeekday'));
  print('request sent');
  request.headers['Content-Type'] = 'application/json';

  request.body = json.encode({'weekday': day, 'value': value});
  await sendRequest(request);
}
