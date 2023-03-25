import 'package:flutter/material.dart';

class LatLongProvider with ChangeNotifier {
  String _lat = '00.00';
  String _lng = '00.00';

  String get selectedLat => _lat;
  String get selectedLng => _lng;

  void setFilter(lat, lng) {
    _lat = lat;
    _lng = lng;
    notifyListeners();
  }
}
