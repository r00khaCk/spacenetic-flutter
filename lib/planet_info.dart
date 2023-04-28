import 'dart:convert';
import 'package:flutter/services.dart';

class PlanetDetails {
  final String name;
  final String imagePath;
  final String description;

  PlanetDetails({
    required this.name,
    required this.imagePath,
    required this.description,
  });
}

Future<List<PlanetDetails>> loadPlanetDetails() async {
  String jsonContent =
      await rootBundle.loadString('assets/planet_details.json');
  final jsonResult = jsonDecode(jsonContent);
  List<PlanetDetails> planetDetails = [];
  for (var planet in jsonResult['planet_details']) {
    PlanetDetails planetDetail = PlanetDetails(
        name: planet['name'],
        imagePath: planet['imagePath'],
        description: planet['description']);
    planetDetails.add(planetDetail);
  }
  return planetDetails;
}
