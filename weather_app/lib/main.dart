import 'package:flutter/material.dart';
import 'package:myapp/weather_service.dart';
import 'package:intl/intl.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _weatherData;
  final WeatherService _weatherService = WeatherService();
  String _errorMessage = '';

  void _fetchWeather() async {
    final city = _controller.text;
    if (city.isNotEmpty) {
      final data = await _weatherService.fetchWeather(city);
      print("API Response: $data"); // Debugging line
      if (data != null) {
        setState(() {
          _weatherData = data;
          _errorMessage = ''; // Clear error message on success
        });
      } else {
        setState(() {
          _weatherData = null;
          _errorMessage = 'Failed to load weather data. Please try again.';
        });
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _formatTime(int? timestamp) {
    if (timestamp == null) return 'N/A';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _getGreeting(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter City',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _fetchWeather,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 20),
            if (_weatherData != null) ...[
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${_weatherData!['name'] ?? 'Unknown'}, ${_weatherData!['sys']?['country'] ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${_weatherData!['main']?['temp']?.toStringAsFixed(1) ?? 'N/A'}°C',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Text(
                        '${_weatherData!['weather']?[0]?['description'] ?? 'N/A'}',
                        style: TextStyle(
                            fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.water_drop, color: Colors.blue),
                              SizedBox(height: 5),
                              Text(
                                '${_weatherData!['main']?['humidity'] ?? 'N/A'}%',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text('Humidity'),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.wind_power, color: Colors.blue),
                              SizedBox(height: 5),
                              Text(
                                '${_weatherData!['wind']?['speed'] ?? 'N/A'} m/s',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text('Wind Speed'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Sunrise: ${_formatTime(_weatherData!['sys']?['sunrise'])}',
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      ),
                      Text(
                        'Sunset: ${_formatTime(_weatherData!['sys']?['sunset'])}',
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
              ),
            ] else
              Center(child: Text('No data found.')),
          ],
        ),
      ),
    );
  }
}
