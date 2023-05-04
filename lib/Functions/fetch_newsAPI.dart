import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spacenetic_flutter/Classes/news_modal.dart';
// import 'package:spacenetic_flutter/Classes/planets_api_modal.dart';
// import '../Classes/planets_local_modal.dart';

class FetchNewsAPI {
  //String apiKey = 'eGR/0NxGMAX1bTWckJZD6g==FUnphEgVDRCeNyn8';

  Future<List<NewsModal>> getNewsAPI() async {
    List<NewsModal> list;
    var response = await http.get(
      Uri.parse('https://api.spaceflightnewsapi.net/v3/articles'),
    );

    if (response.statusCode == 200) {
      var planets = jsonDecode(response.body);
      var rest = planets as List;
      print(rest);
      list = rest
          .map<NewsModal>(
            (json) => NewsModal.fromJson(json),
          )
          .toList();
    } else {
      throw "Something went wrong!\n${response.statusCode}";
    }
    return list;
  }
}
