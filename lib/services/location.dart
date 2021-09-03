import 'package:geolocator/geolocator.dart';

class Location {
  double? longitude;
  double? latitude;

  Future<void> getCurruntLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      longitude = position.longitude;
      latitude = position.latitude;
      // print('++++++++++++++++ Longitude: $longitude Latitude: $latitude');
    } catch (exception) {
      print('Location exception::: $exception');
    }
  }
}
