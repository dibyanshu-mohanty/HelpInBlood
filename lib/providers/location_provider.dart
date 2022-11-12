import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class Locations with ChangeNotifier {
  // Get Current Location
  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Please Turn on Location permissions manually');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Get Location Stream
  final user = FirebaseAuth.instance.currentUser;
  StreamSubscription<Position>? _locationSubscription;
  Future<void> listenLocation(BuildContext context) async {
    _locationSubscription = Geolocator.getPositionStream(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.high))
        .handleError((error) {
      _locationSubscription!.cancel();
      Fluttertoast.showToast(msg: "Error in Fetching location");
    }).listen((position) async {
      GeoFirePoint myLocation = Geoflutterfire()
          .point(latitude: position.latitude, longitude: position.longitude);
      FirebaseFirestore.instance.collection('locations').doc(user!.uid).set(
          {'name': user!.email, 'position': myLocation.data},
          SetOptions(merge: true));
    });
    notifyListeners();
  }

  void stopListening(BuildContext context) {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    notifyListeners();
  }
}
