import 'dart:developer';
import 'package:book_my_show_clone_web/models/address.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocode/geocode.dart' as geocode;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  double latitude = 37.421632;
  double longitude = 12.084664;
  bool permissionAllowed = false;

  Address currentLocation = Address();
  bool loading = false;

  Future getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude;
    longitude = position.longitude;
    log("latitude: $latitude");
    log("longitude: $longitude");

    permissionAllowed = true;

    notifyListeners();

    return _findAddress();
  }

  _findAddress() async {
    geocode.GeoCode geoCode = geocode.GeoCode();

    try {
      geocode.Address place = await geoCode.reverseGeocoding(
          latitude: latitude, longitude: longitude);

      String address =
          '${place.streetNumber}, ${place.streetAddress}, ${place.region},  ${place.countryName}, ${place.postal}';
      //print("current location.......$address");
      String city = place.city.toString();
      String street = "${place.streetAddress} ${place.streetAddress}";
      String state = place.region.toString();
      String country = place.countryName.toString();
      String locality = place.region.toString();
      String zip = place.postal.toString();

      currentLocation.placeFormattedAddress = address;
      currentLocation.street = street;
      currentLocation.locality = locality;
      currentLocation.country = country;
      currentLocation.stateOrProvince = state;
      currentLocation.city = city;
      currentLocation.postalCode = zip;
      notifyListeners();

      return currentLocation;
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      return currentLocation;
    }
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    latitude = cameraPosition.target.latitude;
    longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  void getLatLng(double latitude, double longitude) {
    this.latitude = latitude;
    this.longitude = longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    await _findAddress();

    notifyListeners();
  }
}
