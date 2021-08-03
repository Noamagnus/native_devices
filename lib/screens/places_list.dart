import 'package:flutter/material.dart';
import 'package:native_devices_app/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

import '../screens/add_place_screen.dart';
import '../providers/great_places.dart';

class PlacesListScreen extends StatelessWidget {
  static const routeName = '/PlaceListScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your places'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddPlaceScreen.routeName);
            },
            icon: Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: context.read<GreatPlaces>().fetchAndSetPlaces(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? CircularProgressIndicator()
                : Consumer<GreatPlaces>(
                    child: Center(
                      child: Text('Got no places yet! Start adding some'),
                    ),
                    builder: (context, greatPlace, ch) =>
                        greatPlace.items.length <= 0
                            ? ch!
                            : ListView.builder(
                                itemCount: greatPlace.items.length,
                                itemBuilder: (context, i) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        FileImage(greatPlace.items[i].image),
                                  ),
                                  title: Text(greatPlace.items[i].title),
                                  subtitle: Text(
                                    greatPlace.items[i].location!.address,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, PlaceDetailScreen.routeName,
                                        arguments: greatPlace.items[i].id);
                                  },
                                ),
                              ),
                  ),
      ),
    );
  }
}
