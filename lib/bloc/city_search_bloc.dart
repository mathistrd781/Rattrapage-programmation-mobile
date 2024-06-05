import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/weather_service.dart';
import '../services/geocoding_service.dart';

// Events
abstract class CitySearchEvent extends Equatable {
  const CitySearchEvent();

  @override
  List<Object> get props => [];
}

class CitySearchRequested extends CitySearchEvent {
  final String cityName;

  const CitySearchRequested(this.cityName);

  @override
  List<Object> get props => [cityName];
}

// States
abstract class CitySearchState extends Equatable {
  const CitySearchState();

  @override
  List<Object> get props => [];
}

class CitySearchInitial extends CitySearchState {}

class CitySearchLoading extends CitySearchState {}

class CitySearchSuccess extends CitySearchState {
  final Map<String, dynamic> weatherData;

  const CitySearchSuccess(this.weatherData);

  @override
  List<Object> get props => [weatherData];
}

class CitySearchFailure extends CitySearchState {
  final String error;

  const CitySearchFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Bloc
class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {
  final WeatherService weatherService;
  final GeocodingService geocodingService;

  CitySearchBloc({required this.weatherService, required this.geocodingService}) : super(CitySearchInitial()) {
    on<CitySearchRequested>(_onCitySearchRequested);
  }

  Future<void> _onCitySearchRequested(CitySearchRequested event, Emitter<CitySearchState> emit) async {
    emit(CitySearchLoading());
    try {
      final coordinates = await geocodingService.getCoordinates(event.cityName);
      final weatherData = await weatherService.fetchDailyWeather(coordinates['latitude'], coordinates['longitude']);
      emit(CitySearchSuccess(weatherData));

      // Log the success state
      print('Weather data loaded successfully for: ${event.cityName}');
    } catch (error) {
      emit(CitySearchFailure(error.toString()));

      // Log the failure state
      print('Failed to load weather data for: ${event.cityName}, error: $error');
    }
  }
}
