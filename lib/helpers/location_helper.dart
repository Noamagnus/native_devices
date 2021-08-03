import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert'; //for converting data from and to json

const GOOGLE_API_KEY = 'AIzaSyAPgzGwmCq3cInF5Fe3tV9QPF-e1ZpuFuQ';

class LocationHelper {
  static String? generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final params = {
      'latlng': '$lat,$lng',
      'key': GOOGLE_API_KEY,
    };
    final url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/geocode/json',
      params,
    );
    final response = await http.get(url);
    print("Response je ${response.body}");
    final json = jsonDecode(response.body);
    print(json['results'][0]['address_components'][1]['long_name']);
    return json['results'][0]['address_components'][1]['long_name'];
  }
}
