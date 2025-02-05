import 'package:flutter/material.dart';
import 'services/weather_service.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  String errorMessage = '';

  // Function to get weather
  void getWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final data = await _weatherService.fetchWeather(_controller.text);
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      setState(() {
        errorMessage = "City not found! Try again.";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  // Function to determine background color based on weather
  Color getBackgroundColor() {
    if (weatherData == null) return Colors.blueGrey;
    String condition = weatherData!['weather'][0]['main'].toLowerCase();
    if (condition.contains("cloud")) return Colors.grey;
    if (condition.contains("rain")) return Colors.blue;
    if (condition.contains("clear")) return Colors.orange;
    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather App")),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [getBackgroundColor(), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input Field
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter City Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Get Weather Button
            ElevatedButton(
              onPressed: getWeather,
              child: Text("Get Weather"),
            ),
            SizedBox(height: 20),

            // Loading Indicator
            if (isLoading) CircularProgressIndicator(),

            // Error Message
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red)),

            // Weather Information
            if (weatherData != null) ...[
              Icon(
                Icons.wb_sunny, // Can be updated based on weather
                size: 50,
                color: Colors.orange,
              ),
              SizedBox(height: 10),
              Text(
                "Temperature: ${weatherData!['main']['temp']}°C",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "Condition: ${weatherData!['weather'][0]['description']}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
