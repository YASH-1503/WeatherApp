import 'package:flutter/material.dart';
// import 'package:weatherapp/models/WeatherModel.dart';

import '../models/WeatherModel.dart';

class WeatherScreen extends StatelessWidget {
  final WeatherModel weather;

  WeatherScreen({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'City: ${weather.cityName}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Temperature: ${weather.temperature.toString()}°C',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Description: ${weather.weatherDescription}',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
