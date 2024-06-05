import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/city_search_bloc.dart';
import 'screens/city_search_screen.dart';
import 'services/weather_service.dart';
import 'services/geocoding_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WeatherService weatherService = WeatherService();
    final GeocodingService geocodingService = GeocodingService();
    return MaterialApp(
      title: 'Weather App',
      home: BlocProvider(
        create: (context) => CitySearchBloc(weatherService: weatherService, geocodingService: geocodingService),
        child: CitySearchScreen(),
      ),
    );
  }
}
