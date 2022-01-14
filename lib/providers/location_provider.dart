// ignore_for_file: unnecessary_this, unnecessary_null_comparison, avoid_print, unnecessary_new, unused_local_variable, prefer_typing_uninitialized_variables, import_of_legacy_library_into_null_safe

import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  late double latitiude;
  late double longitude;
  bool permissionAllowed = false;
  var selectedAddress;
  bool loading = false;

  Future<void> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      this.latitiude = position.latitude;
      this.longitude = position.longitude;

      final coordinates = new Coordinates(this.latitiude, this.longitude);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      this.selectedAddress = addresses.first;

      this.permissionAllowed = true;
      notifyListeners();
    } else {
      print('Permission not allowed');
    }
  }

  void onCameraMove(CameraPosition cameraposition) async {
    this.latitiude = cameraposition.target.latitude;
    this.longitude = cameraposition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    // final coordinates = new Coordinates(this.latitiude, this.longitude);
    // final addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // this.selectedAddress = addresses.first;
    print("${selectedAddress.featureName} : ${selectedAddress.addressLine}");
  }
}
