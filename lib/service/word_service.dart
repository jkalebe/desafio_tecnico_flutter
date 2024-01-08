import 'package:dictionary_app/models/word_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WordService {
  final url = 'https://api.dictionaryapi.dev/api/v2/entries/en/';
  Future<WordDetails> fetchWordDetails(String word) async {
    final response = await http.get(Uri.parse(url+word));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return WordDetails.fromJson(jsonResponse.first as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load word details');
    }
  }
}
