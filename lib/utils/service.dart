import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {

  static const String _token = "AAAAAAAAAAAAAAAAAAAAAE15yQAAAAAAKm0zX731n%2F7G6Pss6rhat6JHO8E%3D8mhnSAxLTl0s9AloZeye6GOI7cVdBfTR8hChmqvHrFLOfOhqJc";

  static getAllTweets(url) async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception("Error making a get request!");
    } on Exception {
      print("Something went wrong!");
    }
  }

}