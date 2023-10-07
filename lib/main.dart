// import 'package:flutter/material.dart';
// // import 'package:weather_app/screens/WeatherScreen.dart';
// import 'package:weatherapp/screens/WeatherScreen.dart';
//
// import 'models/WeatherModel.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: WeatherScreen(
//         weather: WeatherModel(
//           cityName: 'New York',
//           temperature: 20.0,
//           weatherDescription: 'Sunny',
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/WeatherModel.dart'; // Assuming WeatherModel.dart is in the same directory


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationWeatherScreen(),
    );
  }
}

class LocationWeatherScreen extends StatefulWidget {
  @override
  _LocationWeatherScreenState createState() => _LocationWeatherScreenState();
}

class _LocationWeatherScreenState extends State<LocationWeatherScreen> {
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    getWeatherData(_locationData!.latitude!, _locationData!.longitude!);
  }

  Future<void> getWeatherData(double lat, double lon) async {
    final apiKey = 'YOUR_API_KEY'; // Replace with your API key
    final url = 'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String cityName = data['name'];
      final double temperature = data['main']['temp'];
      final String weatherDescription = data['weather'][0]['description'];

      WeatherModel weather = WeatherModel(cityName, temperature, weatherDescription);

      // Now you can use the weather object in your UI
      setState(() {
        _weather = weather;
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  WeatherModel? _weather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: _weather != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'City: ${_weather!.cityName}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Temperature: ${_weather!.temperature}°C',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Description: ${_weather!.weatherDescription}',
              style: TextStyle(fontSize: 24),
            ),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}

class WeatherModel {
  final String cityName;
  final double temperature;
  final String weatherDescription;

  WeatherModel(this.cityName, this.temperature, this.weatherDescription);
}
