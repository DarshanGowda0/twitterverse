import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:twitterverse/models/tweet.dart';

class ApiService {
  static const String _token =
      "AAAAAAAAAAAAAAAAAAAAAE15yQAAAAAAKm0zX731n%2F7G6Pss6rhat6JHO8E%3D8mhnSAxLTl0s9AloZeye6GOI7cVdBfTR8hChmqvHrFLOfOhqJc";

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
    } on Exception catch (ex) {
      print("Something went wrong!" + ex.toString());
    }
  }

  static const String _metaUrl = "http://54.152.12.204:5000/metadata?url=";

  static getMetaData(Tweet tweet) async {
    print("hittting " + tweet.url);
    if (tweet.url == "") {
      return {
        "meta": "",
        "tweet": tweet,
      };
    }

    try {
      var response = await http.get(_metaUrl + tweet.url);
      print(response.statusCode.toString() + " " + response.body);
      if (response.statusCode == 200) {
        return {
          "meta": json.decode(response.body),
          "tweet": tweet,
        };
      }
      throw Exception("Error making a get request!");
    } on Exception catch (ex) {
      print("Something went wrong!" + ex.toString());
    }
  }
}
