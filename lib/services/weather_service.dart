import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_keys.dart';

class WeatherService {
  static const String baseUrl =
      "https://api.openweathermap.org/data/2.5/weather";

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url =
        Uri.parse("$baseUrl?q=$city&appid=$openWeatherApiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("City not found");
    }
  }
}
