import 'dart:math';
import 'package:blood_bank/data/blood_quote_data.dart';
import 'package:blood_bank/screens/choose_blood.dart';
import 'package:blood_bank/screens/donor_register.dart';
import 'package:blood_bank/screens/subScreens/campaign_screen.dart';
import 'package:blood_bank/screens/subScreens/login_screen.dart';
import 'package:blood_bank/screens/subScreens/notifications.dart';
import 'package:blood_bank/screens/subScreens/search_blood_requests.dart';
import 'package:blood_bank/widgets/location_toggle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        extendBody: true,
        drawer: Drawer(
          width: 70.w,
          child: SafeArea(
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CampaignScreen()));
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.campaign,
                      size: 8.w,
                      color: Colors.black,
                    ),
                    title: Text(
                      "Donation Camps",
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 4.w, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                    width: 40.w,
                    child: const Divider(
                      thickness: 1.0,
                      color: Colors.black,
                    )),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchBloodRequests()));
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.request_page_outlined,
                      size: 8.w,
                      color: Colors.black,
                    ),
                    title: Text(
                      "Check Status",
                      softWrap: true,
                      style:
                      TextStyle(fontSize: 4.w, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                FirebaseAuth.instance.currentUser != null
                    ? Column(
                        children: [
                          SizedBox(
                              width: 40.w,
                              child: const Divider(
                                thickness: 1.0,
                                color: Colors.black,
                              )),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                            },
                            child: ListTile(
                              leading: Icon(
                                Icons.notifications,
                                size: 8.w,
                                color: Colors.black,
                              ),
                              title: Text(
                                "Check Requests",
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 4.w, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: StreamBuilder(
                stream: Stream.value(FirebaseAuth.instance.currentUser),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Color(0xFFE60026),
                    );
                  }
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "HelpIn",
                                  style: TextStyle(
                                      fontSize: 12.w,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: "Poppins")),
                              TextSpan(
                                  text: "Blood",
                                  style: TextStyle(
                                      fontSize: 14.w,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFFF033E),
                                      fontFamily: "Poppins"))
                            ])),
                            Text(
                              "Connecting you in the hour of need",
                              style: TextStyle(
                                  fontSize: 4.w, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChooseBlood()));
                          },
                          child: Lottie.asset("assets/images/add_new.json",height: 36.h)
                        ),
                        FirebaseAuth.instance.currentUser != null
                            ? const LocationToggle()
                            : Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DonorRegistration()));
                                    },
                                    child: Card(
                                      elevation: 4.0,
                                      color: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.w, vertical: 3.h),
                                          child: Text(
                                            "Register as a Donor",
                                            style: TextStyle(
                                                fontSize: 4.w,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    },
                                    child: RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: "Already a Donor? ",
                                          style: TextStyle(
                                              fontSize: 3.w,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black)),
                                      TextSpan(
                                          text: "Log In",
                                          style: TextStyle(
                                              fontSize: 3.5.w,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFFFF033E)))
                                    ])),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  );
                })));
  }
}
