import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/weather_service.dart';

// Events
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherRequested extends WeatherEvent {
  final String city;
  final double latitude;
  final double longitude;

  const WeatherRequested(this.city, this.latitude, this.longitude);

  @override
  List<Object> get props => [city, latitude, longitude];
}

// States
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Map<String, dynamic> dailyWeather;
  final Map<String, dynamic> hourlyWeather;

  const WeatherLoaded(this.dailyWeather, this.hourlyWeather);

  @override
  List<Object> get props => [dailyWeather, hourlyWeather];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService weatherService;

  WeatherBloc({required this.weatherService}) : super(WeatherInitial()) {
    on<WeatherRequested>(_onWeatherRequested);
  }

  Future<void> _onWeatherRequested(WeatherRequested event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final dailyWeather = await weatherService.fetchDailyWeather(event.latitude, event.longitude);
      final hourlyWeather = await weatherService.fetchHourlyWeather(event.latitude, event.longitude);
      emit(WeatherLoaded(dailyWeather, hourlyWeather));
    } catch (error) {
      emit(WeatherError(error.toString()));
    }
  }
}
