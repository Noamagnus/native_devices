import 'package:flutter/material.dart';
import 'package:native_devices_app/screens/add_place_screen.dart';
import 'package:native_devices_app/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import '../screens/places_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: PlacesListScreen(),
        routes: {
          AddPlaceScreen.routeName: (context) => AddPlaceScreen(),
          PlacesListScreen.routeName: (context) => PlacesListScreen(),
          PlaceDetailScreen.routeName: (context) => PlaceDetailScreen(),
        },
      ),
    );
  }
}
