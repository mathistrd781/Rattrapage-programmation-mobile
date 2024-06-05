import 'package:equatable/equatable.dart';

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
