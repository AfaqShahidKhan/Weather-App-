import 'package:flutter/material.dart';
import 'package:weather/screens/city_screen.dart';
import 'package:weather/utilities/constants.dart';
import 'package:weather/services/weather.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  LocationScreen(this.locationWeather);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  int? temperature;
  String? weatherIcon;
  String? cityName;
  String? countryName;
  String? weatherMessage;
  String? conditions;
  int? humidity;
  double? minTemp;
  double? maxTemp;
  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(
      () {
        if (weatherData == null) {
          temperature = 0;
          weatherIcon = 'Error';
          weatherMessage = 'Unable to get weather data';
          cityName = '';
          return;
        }
        var temp = weatherData['main']['temp'];
        temperature = temp.toInt();
        minTemp = weatherData['main']['temp_min'];
        maxTemp = weatherData['main']['temp_max'];
        var condition = weatherData['weather'][0]['id'];
        weatherIcon = weather.getWeatherIcon(condition);
        var wCondition = weatherData['weather'][0]['main'];
        conditions = weatherData['weather'][0]['main'];
        // print('$condition, $wCondition');
        weatherMessage = weather.getMessage(temperature!);
        cityName = weatherData['name'];
        countryName = weatherData['sys']['country'];
        humidity = weatherData['main']['humidity'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      // print('---++++++-- ${weatherData.toString()}------');

                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  Text(
                    'Enter City by pressing Building icon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      print('-----++++$typedName++++-----');
                      if (typedName != null) {
                        weather.getCityWeather(typedName);
                        var weatherData =
                            await weather.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$weatherIcon',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherMessage\' $cityName  ',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  double temperature = decodedData['main']['temp'];
//       int condition = decodedData['weather'][0]['id'];
//       String cityName = decodedData['name'];
