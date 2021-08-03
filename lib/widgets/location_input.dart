import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:developer';

import 'package:location/location.dart';
import 'package:native_devices_app/models/place.dart';
import 'package:native_devices_app/screens/map_screen.dart';

import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  const LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude!, locData.longitude!);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (e) {
      print(e);
      return;
    }
    // print(locData.latitude);
    // print(locData.longitude);
  }

  Future<void> _selectOnMap() async {
    //we'll get selected location after we pop out Map
    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    //if user didn't select location on the map(only closed map)
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);

    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);

    log("${selectedLocation.longitude}");
    log("${selectedLocation.latitude}");
  }

  @override
  Widget build(BuildContext context) {
    print('Misa');
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: _previewImageUrl == null
              ? Text(
                  'No location chosen',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current location'),
              style: TextButton.styleFrom(
                  textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              )),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Select on map'),
              style: TextButton.styleFrom(
                  textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              )),
            )
          ],
        )
      ],
    );
  }
}
