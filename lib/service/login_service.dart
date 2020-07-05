import 'dart:async';
import 'dart:io';
import 'package:my_shop/service/http_call_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoginService {

  HTTPService httpservice = new HTTPService();

  getUserLogin(url, headers, body, context) async {

    var response;

    try {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(body)));
      response = await request.close();
      // todo - you should check the response.statusCode
      httpClient.close();
    } catch(e) {
      rethrow;
    }
    return response;
  }
}