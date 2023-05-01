import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacenetic_flutter/Classes/planets_api_modal.dart';

import '../Classes/planets_local_modal.dart';

// class FetchPlanetAPI {
// Future<PlanetsAPIModal> getPlanetAPI() async {
//   final response = await http.get(
//       Uri.parse('https://api.api-ninjas.com/v1/planets?name=Earth'),
//       headers: {'X-Api-Key': api_key});

//   if (response.statusCode == 200) {
//     return PlanetsAPIModal.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception(response.reasonPhrase);
//   }
// }
// }
class FetchPlanetAPI {
  String api_key = 'eGR/0NxGMAX1bTWckJZD6g==FUnphEgVDRCeNyn8';

  Future<List<PlanetsAPIModal>> getPlanetAPI(String planetName) async {
    List<PlanetsAPIModal> list;
    var response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/planets?name=${planetName}'),
        headers: {'X-Api-Key': api_key});

    if (response.statusCode == 200) {
      var planets = jsonDecode(response.body);
      var rest = planets as List;
      print(rest);
      list = rest
          .map<PlanetsAPIModal>((json) => PlanetsAPIModal.fromJson(json))
          .toList();
      // planets.map((e) => PlanetsAPIModal.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
    // print(list);
    return list;
  }
  //print(response.body);
  // var planets = <PlanetsAPIModal>[];
  // if (response.statusCode == 200) {
  //   var planetsJson = jsonDecode(response.body);
  //   for (var planetJson in planetsJson) {
  //     planets.add(PlanetsAPIModal.fromJson(planetJson));
  //   }
  //   //return PlanetsAPIModal.fromJson(jsonDecode(response.body));
  // } else {
  //   throw Exception(response.reasonPhrase);
  // }
  // return planets;
}
