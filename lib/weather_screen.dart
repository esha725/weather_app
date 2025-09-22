import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additonal_info_item.dart' show AdditonalInfoItem;
import 'package:weather_app/hourly_forecast_name.dart' show HourlyForcastItem;
import 'package:http/http.dart' as http;
import 'config.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}
 


class _WeatherScreenState extends State<WeatherScreen> {
late Future<Map<String, dynamic>> weather;
TextEditingController cityController = TextEditingController();
String cityName = 'London';
  Future<Map<String, dynamic>> getCurrentWeather() async {
  try {
    final res = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$OPEN_WEATHER_KEY'),
    );
    final data = jsonDecode(res.body);

    // Error checking
    if (data['cod'] != "200") {
      throw 'API Error: ${data['message'] ?? 'Unknown error'}';
    }

    return data;
  } catch (e) {
    throw e.toString();
  }
}

  @override
  void initState() {
    super.initState();
    weather= getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

  appBar: AppBar(
    title: const Text(
    'Weather App' ,
    style: TextStyle(
    fontWeight: FontWeight.bold,
    ),
    ),
    centerTitle: true,
    actions: [
      IconButton(onPressed:() {
        setState(() {
          weather = getCurrentWeather();
        });
      } , icon: Icon(Icons.refresh)),
    ],
    ),
    body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField to enter city
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      cityName = cityController.text;
                      weather = getCurrentWeather();
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  cityName = value;
                  weather = getCurrentWeather();
                });
              },
            ),
      const SizedBox(height: 16),

      Expanded(child: FutureBuilder(
      future: weather,
      builder: (context, snapshot) { 
        if(snapshot.connectionState ==ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator.adaptive());
        }
        if(snapshot.hasError) {
          return Center( child: Text(snapshot.error.toString()));
        }

        final data = snapshot.data!;
        final currentWeatherData= data['list'][0];
        final currentTemp = currentWeatherData['main']?['temp']?.toString() ?? '0';
        final currentSky = currentWeatherData['weather']?[0]?['main']?.toString() ?? 'Clear';
        final currentPressure = currentWeatherData['main']?['pressure']?.toString() ?? '0';
        final currentWindSpeed = currentWeatherData['wind']?['speed']?.toString() ?? '0';
        final currentHumidity = currentWeatherData['main']?['humidity']?.toString() ?? '0';


        return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 4,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                color: Colors.white38,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(currentTemp,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        SizedBox(height: 10),
                        Icon(
                          currentSky == 'Clouds' || currentSky == 'Rain' ?
                          Icons.cloud: Icons.sunny, size: 54),
                        SizedBox(height: 10),
                        Text(currentSky, style: const TextStyle(fontSize: 19),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          const Text('Weather Forcast',
          style: TextStyle(fontSize: 25,
          fontWeight: FontWeight.bold
          ),
          ),
          //hourly forecast card
          const SizedBox(height: 08),

             SizedBox(
            height: 140,
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index)   {
                final hourlyForecast = data['list'][index + 1];
                final hourlySky = hourlyForecast['weather']?[0]?['main']?.toString() ?? 'Clear';
                final hourlyTemp = hourlyForecast['main']?['temp']?.toString() ?? '0';
                final dtTxt = hourlyForecast['dt_txt']?.toString() ?? '';
                final time = dtTxt.isNotEmpty ? DateTime.parse(dtTxt) : DateTime.now();

                return HourlyForcastItem(
                  time: DateFormat.j().format(time), 
                  icon: hourlySky == 'Clouds' || 
                  hourlySky == 'Rain'? 
                  Icons.cloud: Icons.sunny,
                  temp: hourlyTemp,
                  );
              },
            ),
          ),


          //additional info card
          const SizedBox(height: 08),
          const Text('Additonal Information',
          style: TextStyle(fontSize: 25,
          fontWeight: FontWeight.bold
          ),
          ),
          // Additional info row
          const SizedBox(height: 08),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              AdditonalInfoItem(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: currentHumidity.toString(),
              ),
              AdditonalInfoItem(
                icon: Icons.air,
                label: 'Wind Speed',
                value: currentWindSpeed.toString(),
              ),
              AdditonalInfoItem(
                icon: Icons.beach_access,
                label: 'Pressure',
                value: currentPressure.toString(),
              ),
               ],  
              ),
             ], 
            ),
           );
      },
       ),
      ),
      ]
     ),
    ),
   );
  }
}
