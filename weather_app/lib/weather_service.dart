import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey =
      '6f71eaf1b36f8687fe9b66de54cb7228'; // Replace with your actual API key

  Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body); // Returns parsed JSON data
      } else {
        print('Failed to fetch weather data: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}
