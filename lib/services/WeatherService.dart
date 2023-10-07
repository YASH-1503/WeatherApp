import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;
  final String baseUrl;

  WeatherService({required this.apiKey, required this.baseUrl});

  Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$city&appid=$apiKey'));
    return json.decode(response.body);
  }
}
