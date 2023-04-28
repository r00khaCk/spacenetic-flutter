class PlanetsAPIModal {
  final double? mass;
  final double? radius;
  final int? temperature;
  final double? distanceLightYear;

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
