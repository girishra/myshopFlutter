import 'dart:async';
import 'dart:io';
import 'package:my_shop/config/AppConfig.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/material.dart';


class HTTPService {

  httpPost(url, headers, body, context) async {
    final Uri resolved = Uri.base.resolve(url);
    final http.Response response =  await http.patch(resolved, headers: headers, body: body);

    
    print(response);
    AppConfig.httpStatusCodeRec = response.statusCode;
    
    if (response == null || response.statusCode != 200)
      throw new Exception('HTTP request failed, statusCode: ${response?.statusCode}, $resolved');

    if (response.statusCode == 500){
      throw new Exception('HTTP internal server error , statusCode: ${response?.statusCode}, $resolved');
    }

    if(response != null && response.statusCode == 200)
      return response.body;
  }

  
//  Future httpPost(url, headers, body) async {
//    bool trustSelfSigned = true;
//    HttpClient httpClient = new HttpClient()
//      ..badCertificateCallback =
//      ((X509Certificate cert, String host, int port) => trustSelfSigned);
//    IOClient ioClient = new IOClient(httpClient);
//    await ioClient.post(url, body:body);
//    ioClient.close();
//    return ioClient.toString();
//  }

}