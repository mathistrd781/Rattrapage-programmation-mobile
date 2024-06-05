import 'package:equatable/equatable.dart';

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
