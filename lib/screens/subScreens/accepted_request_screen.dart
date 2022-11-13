import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptedRequestScreen extends StatelessWidget {
  final String phNo;
  final Map<String, dynamic> position;
  const AcceptedRequestScreen(
      {Key? key, required this.phNo, required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            "Request Notifications",
            style: TextStyle(
                fontSize: 4.w,
                fontWeight: FontWeight.w300,
                color: Colors.black),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: SafeArea(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 2.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Lottie.asset("assets/images/succesanimation.json", height: 35.h),
              Text(
                "Congratulations ! You have successfully volunteered to save a life and you can connect with the victim via:",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 4.w),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    phNo,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 5.w),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  GestureDetector(
                      onTap: () async {
                        Uri callUrl = Uri.parse('tel:=$phNo');
                        if (await canLaunchUrl(callUrl)) {
                          await launchUrl(callUrl);
                        } else {
                          throw 'Could not open the dialler.';
                        }
                      },
                      child: const Icon(
                        Icons.phone,
                        color: Colors.black,
                      )),
                ],
              ),
              TextButton(
                  onPressed: () async {
                    final url = Uri.parse(
                        "http://maps.google.com/maps?daddr=${position["latitude"]},${position["longitude"]}&amp;ll=");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not open the dialler.';
                    }
                  },
                  child: Text(
                    "Locate on Map",
                    style: TextStyle(
                        fontSize: 4.w,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFF7209b7)),
                  )),
              Text(
                "Note: Please Refrain from Closing this screen without completing the request. "
                "Please keep the app running in background in order to ensure transparency. Your cooperation is appreciated",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 3.w,
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () async {
                  QuerySnapshot result = await FirebaseFirestore.instance
                      .collection("bloodRequests")
                      .get();
                  final docId = result.docs
                      .firstWhere((element) => element["requestedBy"] == phNo)
                      .id;
                  FirebaseFirestore.instance
                      .collection("bloodRequests")
                      .doc(docId)
                      .update({
                    "isFulfilled": true,
                  });
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0)))),
                child: Text("Mark as Completed.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 3.5.w,
                        fontWeight: FontWeight.w400)),
              )
            ],
          ),
        )),
      ),
    );
  }
}
