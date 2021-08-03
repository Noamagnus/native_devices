import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items => [..._items];

  Place findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> addPlace(
    String pickedTitle,
    File image,
    PlaceLocation pickedLocation,
  ) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    print(address);
    final updatedLocation = PlaceLocation(
        longitude: pickedLocation.longitude,
        latitude: pickedLocation.latitude,
        address: address);
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: pickedTitle,
      location: updatedLocation,
      image: image,
    );
    _items.add(newPlace);
    notifyListeners();
    //'places' is the name we chose and second parameter is Map
    // keys in a map has to match fields we set in CREATE TABLE in DBHelper class
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      // because we need path here, we're not storing file in database we're storing path to the file
      'loc_lat': newPlace.location!.latitude,
      'loc_lng': newPlace.location!.longitude,
      'address': newPlace.location!.address,
      // we can't store file in a dataBase
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            image: File(item['image']), // File is provided by dart.io
            location: PlaceLocation(
              latitude: item['loc_lat'],
              longitude: item['loc_lng'],
              address: item['address'],
            ),
            title: item['title'],
          ),
        )
        .toList();
    notifyListeners();
  }
}
