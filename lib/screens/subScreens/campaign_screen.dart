import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CampaignScreen extends StatelessWidget {
  CampaignScreen({Key? key}) : super(key: key);

  List camps = [];

  Future<void> getCampaigns() async {
    final result =
        await FirebaseFirestore.instance.collection("camapigns").get();
    camps = result.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("Blood Donation Campaigns",style: TextStyle(fontSize: 4.w,fontWeight: FontWeight.w300,color: Colors.black),),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: SafeArea(
          child: SizedBox(
              height: 100.h,
              width: 100.w,
              child: FutureBuilder(
                  future: getCampaigns(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: camps.length,
                      itemBuilder : (context,index) =>
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.black,width: 1.0)
                          ),
                          child: ExpansionTile(
                            childrenPadding:  const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 2.0),
                            leading: const CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.deepOrangeAccent,
                              child: Icon(
                                Icons.campaign_outlined,
                                color: Colors.black,
                              ),
                            ),
                            title: Text(
                              "${camps[index]["title"]}",
                            ),
                            iconColor: Colors.black,
                            textColor: Colors.black,
                            children: [
                              ListTile(
                                title: Text(
                                  "By:",
                                  style: TextStyle(
                                      fontSize: 3.w,
                                      fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text(
                                  "${camps[index]["organisedBy"]}",
                                  style: TextStyle(fontSize: 4.w),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Date:",
                                  style: TextStyle(
                                      fontSize: 3.w,
                                      fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text(
                                  "${camps[index]["date"]}",
                                  style: TextStyle(fontSize: 4.w),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Time:",
                                  style: TextStyle(
                                      fontSize: 3.w,
                                      fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text(
                                  "${camps[index]["time"]}",
                                  style: TextStyle(fontSize: 4.w),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Location :",
                                  style: TextStyle(
                                      fontSize: 3.w,
                                      fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text(
                                  "${camps[index]["location"]}",
                                  style: TextStyle(fontSize: 4.w),
                                ),
                              ),
                            ],
                          ),
                        ),
                    );
                  })),
        ));
  }
}
