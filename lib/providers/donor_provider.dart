
import 'package:blood_bank/providers/request_blood_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'location_provider.dart';

class Donors with ChangeNotifier{
  List<Map<String,dynamic>> _donors =[];
  List<Map<String,dynamic>> get donors{
    return [..._donors];
  }
  List<Map<String,dynamic>> _requests =[];
  List<Map<String,dynamic>> get requests{
    return [..._requests];
  }

  bool _isChecked = false;

  bool get isChecked{
    return _isChecked;
  }
  Future<void> submitData(BuildContext context,String phone, List<String> bloods) async{
    // Provider.of<RequestBlood>(context, listen: false).emptyBloodList();
    FirebaseFirestore.instance.collection("bloodRequests").add({
      "requestedBy" : phone,
      "requiredBlood" : bloods,
      "isFulfilled" : false,
      "time" : DateFormat.yMMMd().format(DateTime.now()),
    });
    final location =
    await Provider.of<Locations>(context, listen: false)
        .getLocation();
    GeoFirePoint center = Geoflutterfire().point(latitude: location.latitude, longitude: location.longitude);
    var collectionReference = FirebaseFirestore.instance.collection('locations');
    double radius = 20;
    String field = 'position';
    Stream<List<DocumentSnapshot>> stream = Geoflutterfire().collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field);
    stream.listen((event) {
      event.forEach((donorElement) async {
        await FirebaseFirestore.instance.collection("users").doc(donorElement.id).collection("notifications").add({
          "requestedBy": phone,
          "requiredBlood": bloods,
        });
        Provider.of<RequestBlood>(context, listen: false).emptyBloodList();
      });
    });
  }

  Future<void> getDonors(String id) async{
    final approvedDonors = await FirebaseFirestore.instance.collection("bloodRequests").doc(id).collection("approvedUsers").get();
    approvedDonors.docs.forEach((element) async{
      final doc = await FirebaseFirestore.instance.collection("users").doc(element["userId"]).get();
      if(doc.exists){
        _donors.add({
          "name" : doc["name"],
          "phone" : doc["phone"],
          "bloodGroup" : doc["bloodGroup"]
        });
      }
      notifyListeners();
    });
  }
  
  Future<void> checkRequestHistory(BuildContext context,String phone) async{
    final results = await FirebaseFirestore.instance.collection("bloodRequests").get();
    final searchResults = results.docs.where((element) => element["requestedBy"] == phone);
    searchResults.forEach((element) async{
        _requests.add({
          "isFulfilled" : element["isFulfilled"],
          "requiredBlood" : element["requiredBlood"],
          "time" : element["time"]
        });
        final String id = element.id;
        await getDonors(id);
    });
    notifyListeners();
  }
  void clearLists(){
    _donors = [];
    _requests = [];
  }

  void toggleCheck(){
    _isChecked = !_isChecked;
    notifyListeners();
  }
}