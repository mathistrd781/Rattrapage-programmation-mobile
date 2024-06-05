import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../bloc/weather_bloc.dart';
import '../services/weather_service.dart';
import '../weather_code.dart';
import '../weather_icons.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class WeatherDetailScreen extends StatelessWidget {
  final String city;
  final double latitude;
  final double longitude;

  WeatherDetailScreen({
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  String getDayName(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('EEEE', 'fr_FR').format(parsedDate);
  }

  String getHour(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return DateFormat('HH:mm', 'fr_FR').format(parsedDate);
  }

  TextStyle textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeDateFormatting('fr_FR', null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return BlocProvider(
            create: (context) => WeatherBloc(weatherService: WeatherService())
              ..add(WeatherRequested(city, latitude, longitude)),
            child: Scaffold(
              appBar: AppBar(title: Text(city, style: textStyle)),
              body: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherInitial) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is WeatherLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is WeatherLoaded) {
                    final dailyWeather = state.dailyWeather;
                    final hourlyWeather = state.hourlyWeather;
                    final daily = dailyWeather['daily'];
                    final hourly = hourlyWeather['hourly'];
                    final weatherDescription = translateWeatherCode(daily['weather_code'][0]);
                    final averageTemperature = ((daily['temperature_2m_max'][0] + daily['temperature_2m_min'][0]) / 2).toStringAsFixed(1);
                    final currentDayName = getDayName(DateTime.now().toIso8601String());
                    final currentMaxTemp = daily['temperature_2m_max'][0];
                    final currentMinTemp = daily['temperature_2m_min'][0];

                    return ListView(
                      padding: EdgeInsets.all(16.0),
                      children: [
                        // Section 1: Weather Description, Weather Icon and Average Temperature
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    getWeatherIcon(daily['weather_code'][0]),
                                    width: 40,
                                    height: 40,
                                    color: Colors.purple,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      weatherDescription,
                                      style: textStyle,
                                    ),
                                  ),
                                  Text(
                                    "$averageTemperature°C",
                                    style: textStyle.copyWith(color: Colors.purple),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  text: "Aujourd'hui le temps est $weatherDescription, la température max est de ",
                                  style: textStyle.copyWith(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "${daily['temperature_2m_max'][0]}°C",
                                      style: textStyle.copyWith(color: Colors.purple),
                                    ),
                                    TextSpan(
                                      text: " et la température minimum de ",
                                    ),
                                    TextSpan(
                                      text: "${daily['temperature_2m_min'][0]}°C",
                                      style: textStyle.copyWith(color: Colors.purple),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Section 2: Temperature and Weather Code for the Next Hours
                        Text(
                          "$currentDayName - ${currentMaxTemp}°C / ${currentMinTemp}°C",
                          style: textStyle.copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(hourly['time'].length, (index) {
                              return MouseRegion(
                                onEnter: (_) {
                                  // Add your hover logic here if needed
                                },
                                onExit: (_) {
                                  // Add your hover logic here if needed
                                },
                                child: Container(
                                  width: 80,
                                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(getHour(hourly['time'][index]), style: textStyle),
                                      SizedBox(height: 4),
                                      SvgPicture.asset(
                                        getWeatherIcon(hourly['weather_code'][index]),
                                        width: 24,
                                        height: 24,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "${hourly['temperature_2m'][index]}°C",
                                        style: textStyle.copyWith(color: Colors.purple),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Section 3: Temperature for the Coming Days
                        Column(
                          children: List.generate(daily['time'].length, (index) {
                            return ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      getDayName(daily['time'][index]),
                                      style: textStyle.copyWith(color: Colors.grey),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    getWeatherIcon(daily['weather_code'][index]),
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "${daily['temperature_2m_max'][index]}°C",
                                    style: textStyle.copyWith(color: Colors.black),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "${daily['temperature_2m_min'][index]}°C",
                                    style: textStyle.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 16),

                        // Section 4: More Info
                        Text(
                          "Plus d'infos",
                          style: textStyle,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/direction-1.svg',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8),
                            Text("Température apparente max: ${daily['apparent_temperature_max'][0]}°C", style: textStyle),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/rain-drop-3.svg',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8),
                            Text("Probabilité de précipitation max: ${daily['precipitation_probability_max'][0]}%", style: textStyle),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/windy-1.svg',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8),
                            Text("Vitesse du vent max: ${daily['wind_speed_10m_max'][0]} km/h", style: textStyle),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/rain-drops-1.svg',
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8),
                            Text("Humidité: 24%", style: textStyle),
                          ],
                        ),
                      ],
                    );
                  } else if (state is WeatherError) {
                    return Center(child: Text('Erreur: ${state.message}', style: textStyle));
                  }
                  return Container();
                },
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
