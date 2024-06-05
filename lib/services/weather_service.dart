import 'dart:convert';
import 'package:http/http.dart' as http;


class WeatherService {
  final String apiUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Map<String, dynamic>> fetchDailyWeather(double latitude, double longitude) async {
    final uri = Uri.parse('$apiUrl?latitude=$latitude&longitude=$longitude&daily=weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,precipitation_probability_max,wind_speed_10m_max');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw Exception('Failed to parse weather data: $e');
      }
    } else {
      throw Exception('Failed to load weather data: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> fetchHourlyWeather(double latitude, double longitude) async {
    final uri = Uri.parse('$apiUrl?latitude=$latitude&longitude=$longitude&hourly=temperature_2m,weather_code&forecast_days=1');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw Exception('Failed to parse weather data: $e');
      }
    } else {
      throw Exception('Failed to load weather data: ${response.reasonPhrase}');
    }
  }
}
