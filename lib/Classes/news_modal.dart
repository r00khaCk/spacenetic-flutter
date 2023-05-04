// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewsModal {
  String? title;
  String? imageURL;
  String? summary;
  String? newsURL;
  String? siteName;
  NewsModal(
      {this.title, this.imageURL, this.summary, this.newsURL, this.siteName});

  factory NewsModal.fromJson(Map<String, dynamic> json) {
    return NewsModal(
        title: json['title'],
        imageURL: json['imageUrl'],
        summary: json['summary'],
        newsURL: json['url']);
  }
}
