import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../providers/location_provider.dart';


class LocationToggle extends StatefulWidget {
  const LocationToggle({Key? key}) : super(key: key);

  @override
  State<LocationToggle> createState() => _LocationToggleState();
}

class _LocationToggleState extends State<LocationToggle> {

  final user = FirebaseAuth.instance.currentUser;
  bool status = false;

  // Future<bool> setLocPref() async {
  //   DocumentSnapshot _docSnap = await FirebaseFirestore.instance
  //       .collection("locPreference")
  //       .doc(userID)
  //       .get();
  //   bool _status = (_docSnap.data() as Map<String, dynamic>)["status"];
  //   return _status;
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locData = Provider.of<Locations>(context);
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.white24))
        // borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Keep your Location On",
              style:
              TextStyle(fontSize: 4.5.w,fontWeight: FontWeight.w600,color: Colors.black),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: Switch(
              inactiveTrackColor: Color(0xFF99EDC3),
              activeTrackColor: Color(0xFF03C04A),
              thumbColor: MaterialStateProperty.all(Color(0xFF028A0F)),
              // iconSize: 20.0,
              value: status,
              onChanged: (val) async {
                setState(() {
                  status = val;
                });
                if (val == false) {
                  locData.stopListening(context);
                  //await Preferences().setLocationPreference(val);
                } else {
                  await locData.listenLocation(context);
                  //await Preferences().setLocationPreference(val);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
