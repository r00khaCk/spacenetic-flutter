// ignore_for_file: public_member_api_docs, sort_constructors_first
class PlanetsLocalModal {
  String? description;
  String? imagePath;
  PlanetsLocalModal({
    this.description,
    this.imagePath,
  });

  PlanetsLocalModal.fromJson(Map<String, dynamic> json) {
    description = json['descripiton'];
    imagePath = json['imagePath'];
  }
}
