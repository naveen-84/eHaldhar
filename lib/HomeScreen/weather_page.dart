import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String location = '';
  Map<String, dynamic>? weatherData;
  bool isDay = true;
  final String apiKey = 'a397b149efb9ca477005d0d85a602c61';

  Future<void> fetchWeatherData(String location) async {
    final weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=$apiKey';

    try {
      final weatherResponse = await http.get(Uri.parse(weatherUrl));
      final weatherJson = json.decode(weatherResponse.body);

      setState(() {
        weatherData = weatherJson;
        final int sunrise = weatherJson['sys']['sunrise'];
        final int sunset = weatherJson['sys']['sunset'];
        final int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        isDay = currentTime > sunrise && currentTime < sunset;
      });
    } catch (error) {
      print('Error fetching weather data: $error');
    }
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    fetchWeatherDataByCoordinates(position.latitude, position.longitude);
  }

  Future<void> fetchWeatherDataByCoordinates(double lat, double lon) async {
    final weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey';

    try {
      final weatherResponse = await http.get(Uri.parse(weatherUrl));
      final weatherJson = json.decode(weatherResponse.body);

      setState(() {
        weatherData = weatherJson;
        final int sunrise = weatherJson['sys']['sunrise'];
        final int sunset = weatherJson['sys']['sunset'];
        final int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        isDay = currentTime > sunrise && currentTime < sunset;
      });
    } catch (error) {
      print('Error fetching weather data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Weather Forecast',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter location',
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (value) => fetchWeatherData(value),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: getCurrentLocation,
              child: Text('Use Current Location'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            SizedBox(height: 20),
            if (weatherData != null) ...[
              Center(
                child: Column(
                  children: [
                    Text(
                      weatherData!['name'],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text('${weatherData!['main']['temp']}°C',
                        style: TextStyle(fontSize: 64, color: Colors.blue)),
                    Text(weatherData!['weather'][0]['description']),
                    Image.network(
                      'https://openweathermap.org/img/wn/${weatherData!['weather'][0]['icon']}@2x.png',
                      width: 80,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
