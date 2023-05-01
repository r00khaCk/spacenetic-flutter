import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacenetic_flutter/Classes/login_modal.dart';

class FetchPotdAPI {
  String nasaAPIKey = 'isfGWgCsBFhgmdK5e58FO36owILPFGgbPcDMgx1B';

  Future<String> fetchImage() async {
    final response = await http.get(
        Uri.parse('https://api.nasa.gov/planetary/apod?api_key=YOUR_API_KEY'),
        headers: {'X-API-Key': nasaAPIKey});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    } else {
      throw Exception('Failed to fetch APOD');
    }
  }
}
