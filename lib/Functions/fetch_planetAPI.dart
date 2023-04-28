import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacenetic_flutter/Classes/planets_api_modal.dart';

class FetchPlanetAPI {
  String api_key = 'eGR/0NxGMAX1bTWckJZD6g==FUnphEgVDRCeNyn8';

  Future<List<PlanetsAPIModal>> getPlanetAPI() async {
    final response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/planets?name=Earth'),
        headers: {'X-Api-Key': api_key});

    if (response.statusCode == 200) {
      final List planets = jsonDecode(response.body);
      return planets.map((e) => PlanetsAPIModal.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
