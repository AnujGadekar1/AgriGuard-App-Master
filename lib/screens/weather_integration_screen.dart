import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherIntegrationScreen extends StatefulWidget {
  @override
  _WeatherIntegrationScreenState createState() =>
      _WeatherIntegrationScreenState();
}

class _WeatherIntegrationScreenState extends State<WeatherIntegrationScreen> {
  final WeatherApi _weatherApi = WeatherApi();
  Map<String, dynamic>? _currentWeather;
  List<Map<String, dynamic>>? _weatherForecast;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      // Request the user's current location
      Position position = await _determinePosition();

      final currentWeather = await _weatherApi.fetchCurrentWeather(
          position.latitude, position.longitude);
      final weatherForecast = await _weatherApi.fetchWeatherForecast(
          position.latitude, position.longitude);
      setState(() {
        _currentWeather = currentWeather;
        _weatherForecast = weatherForecast;
        _isLoading = false;
      });

      // Check weather conditions for alerts
      _checkWeatherConditions();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching weather data: $e';
        _isLoading = false;
      });
    }
  }

  void _checkWeatherConditions() {
    if (_weatherForecast != null) {
      // Check for specific weather conditions
      for (var forecast in _weatherForecast!) {
        if (forecast['condition'].toLowerCase().contains('rain')) {
          _showWeatherAlert(
              'It\'s raining! Please refrain from spreading fertilizers.');
          break; // Stop checking once rain is detected
        }
      }
    }
  }

  // Function to request the user's location
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  bool _isNotificationSilent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Weather Info'), // Weather info text
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
                _isNotificationSilent ? Icons.volume_off : Icons.notifications),
            onPressed: () {
              setState(() {
                _isNotificationSilent = !_isNotificationSilent;
              });
              if (_isNotificationSilent) {
                print('Notification is now silent');
              } else {
                print('Notification is now unsilent');
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '🌤 Current Weather',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      _currentWeather != null
                          ? _buildCurrentWeatherInfo()
                          : Text('No current weather data available'),
                      SizedBox(height: 20),
                      Text(
                        '📅 Weather Forecast',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      _weatherForecast != null
                          ? Expanded(
                              child: _buildWeatherForecast(),
                            )
                          : Text('No weather forecast data available'),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCurrentWeatherInfo() {
    final currentTemperature = _currentWeather!['temperature'];
    final weatherCondition = _currentWeather!['condition'];
    return Column(
      children: [
        Text(
          'Temperature: $currentTemperature°C',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Text(
          'Condition: $weatherCondition',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildWeatherForecast() {
    return ListView.builder(
      itemCount: _weatherForecast!.length,
      itemBuilder: (context, index) {
        final day = _weatherForecast![index]['day'];
        final condition = _weatherForecast![index]['condition'];
        final temperature = _weatherForecast![index]['temperature'];

        // Determine icon based on weather condition
        IconData iconData;
        String weatherText = condition.toLowerCase();
        if (weatherText.contains('cloud')) {
          iconData = Icons.cloud;
        } else if (weatherText.contains('rain')) {
          iconData = Icons.waves;
        } else if (weatherText.contains('clear')) {
          iconData = Icons.wb_sunny;
        } else {
          iconData = Icons.wb_cloudy;
        }

        return ListTile(
          leading: Icon(iconData), // Weather icon
          title: Text(day!),
          subtitle: Text('Condition: $condition, Temperature: $temperature°C'),
        );
      },
    );
  }

  void _showWeatherAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Weather Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class WeatherApi {
  final String apiKey =
      'Replace with your actual API key'; // Replace 'YOUR_API_KEY' with your actual API key

  Future<Map<String, dynamic>> fetchCurrentWeather(
      double latitude, double longitude) async {
    final String apiUrl = 'Replace with your actual API key';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final currentTemperature = data['main']['temp'];
      final weatherCondition = data['weather'][0]['description'];
      return {'temperature': currentTemperature, 'condition': weatherCondition};
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  Future<List<Map<String, dynamic>>> fetchWeatherForecast(
      double latitude, double longitude) async {
    final String apiUrl = 'Replace with your actual API key';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Map<String, dynamic>> forecastData = [];
      for (var item in data['list']) {
        forecastData.add({
          'day': item['dt_txt'],
          'condition': item['weather'][0]['description'],
          'temperature': item['main']['temp'],
        });
      }
      return forecastData;
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Weather App',
    home: WeatherIntegrationScreen(),
  ));
}
