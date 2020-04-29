import 'dart:convert';

import 'package:http/http.dart' as http;

class Networking {
  final String baseURL = 'http://api.giphy.com/v1/gifs/search?q=';
  final String apiKey = '6QTdm0lsVtOADxLdxuzNfFZCXTrdYU6u';

  Future<dynamic> getData(String keyword) async {
    String finalUrl =
        '$baseURL$keyword&api_key=$apiKey&limit=20&offset=0&rating=G&lang=en';
    print(finalUrl);
    http.Response response = await http.get(finalUrl);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
    return null;
  }
}
