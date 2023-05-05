class PlanetsAPIModal {
  final num? mass;
  final num? radius;
  final num? temperature;
  final num? distanceLightYear;

  PlanetsAPIModal(
      {this.mass, this.radius, this.temperature, this.distanceLightYear});

  factory PlanetsAPIModal.fromJson(Map<String, dynamic> json) {
    return PlanetsAPIModal(
        mass: json['mass'],
        radius: json['radius'],
        temperature: json['temperature'],
        distanceLightYear: json['distance_light_year']);
  }
}

// class PlanetsList {
//   final List<PlanetsAPIModal> planets;

//   PlanetsList({required this.planets});
//   // List<Photo> photos = new List<Photo>();
//   //   photos = parsedJson.map((i)=>Photo.fromJson(i)).toList();

//   //   return new PhotosList(
//   //     photos: photos
//   //   );
//   factory PlanetsList.fromJsonToList(List<dynamic> parsedJson) {
//     List<PlanetsAPIModal> planets = <PlanetsAPIModal>[];
//     planets = parsedJson.map((e) => PlanetsAPIModal.fromJson(e)).toList();

//     return PlanetsList(planets: planets);
//   }
// }
