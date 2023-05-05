import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spacenetic_flutter/Classes/planets_api_modal.dart';
import '../Classes/planets_local_modal.dart';

class FetchPlanetAPI {
  final String _apiKey = 'eGR/0NxGMAX1bTWckJZD6g==FUnphEgVDRCeNyn8';

  Future<List<PlanetsAPIModal>> getPlanetAPI(String planetName) async {
    List<PlanetsAPIModal> list;
    var response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/planets?name=$planetName'),
      headers: {'X-Api-Key': _apiKey},
    );

    if (response.statusCode == 200) {
      var planets = jsonDecode(response.body);
      var rest = planets as List;
      print(rest);
      list = rest
          .map<PlanetsAPIModal>(
            (json) => PlanetsAPIModal.fromJson(json),
          )
          .toList();
    } else {
      throw "Something went wrong!\n${response.statusCode}";
    }
    return list;
  }
}
