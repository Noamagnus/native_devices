import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import 'map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/PlaceDetailScreen';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final selectedPlaces = context.read<GreatPlaces>().findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlaces.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlaces.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            selectedPlaces.location!.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    initialLocation: selectedPlaces.location!,
                    isSelecting: false,
                  ),
                ),
              );
            },
            child: Text('View on map'),
            style:
                TextButton.styleFrom(primary: Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}
