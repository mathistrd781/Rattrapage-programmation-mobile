import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/city_search_bloc.dart';
import 'weather_detail_screen.dart';

class CitySearchScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search City')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'City',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    BlocProvider.of<CitySearchBloc>(context).add(
                      CitySearchRequested(_controller.text),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<CitySearchBloc, CitySearchState>(
                builder: (context, state) {
                  if (state is CitySearchInitial) {
                    return Center(child: Text('Enter a city name'));
                  } else if (state is CitySearchLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CitySearchSuccess) {
                    final weatherData = state.weatherData;
                    return ListView.builder(
                      itemCount: 1, // Only show one result as we are searching for a specific city
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_controller.text),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeatherDetailScreen(
                                  city: _controller.text,
                                  latitude: weatherData['latitude'],
                                  longitude: weatherData['longitude'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is CitySearchFailure) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
