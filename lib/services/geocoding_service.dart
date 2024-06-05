import 'dart:convert';
import 'package:http/http.dart' as http;
import '../APIKEY.dart';

class GeocodingService {
  final String apiUrl = 'https://api.opencagedata.com/geocode/v1/json';

  Future<Map<String, dynamic>> getCoordinates(String city) async {
    final uri = Uri.parse('$apiUrl?q=$city&key=${Config.geocodingApiKey}');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        if (data['results'].isNotEmpty) {
          return {
            'latitude': data['results'][0]['geometry']['lat'],
            'longitude': data['results'][0]['geometry']['lng'],
          };
        } else {
          throw Exception('No results found');
        }
      } catch (e) {
        throw Exception('Failed to parse geocoding data: $e');
      }
    } else {
      throw Exception('Failed to load geocoding data: ${response.reasonPhrase}');
    }
  }
}
