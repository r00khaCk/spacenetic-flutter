class PlanetsLocalModal {
  String? name;
  String? description;
  String? imagePath;
  PlanetsLocalModal({
    this.name,
    this.description,
    this.imagePath,
  });

  PlanetsLocalModal.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    imagePath = json['imagePath'];
  }
}
