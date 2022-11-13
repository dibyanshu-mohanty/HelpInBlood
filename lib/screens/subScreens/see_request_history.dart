import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../providers/donor_provider.dart';

class SeeRequestHistory extends StatelessWidget {
  final String phone;
  const SeeRequestHistory({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("Blood Requests",style: TextStyle(fontSize: 4.w,fontWeight: FontWeight.w300,color: Colors.black),),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<Donors>(context, listen: false).clearLists();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: SafeArea(
          child: Container(
              height: 100.h,
              width: 100.w,
              child: FutureBuilder(
                  future: Provider.of<Donors>(context, listen: false)
                      .checkRequestHistory(context, phone),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(strokeWidth: 2.0,),);
                    }
                    return Consumer<Donors>(
                      child: Center(child: Text("No requests found !",style: TextStyle(fontSize: 3.w,fontWeight: FontWeight.w500),),),
                        builder: (context, data, child) {
                          if(data.requests.isEmpty && data.completedRequests.isEmpty){
                            return child!;
                          }
                          return ListView(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Text("Ongoing Requests",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 4.w),),
                                  iconColor: Colors.black,
                                  textColor: Colors.black,
                                  children: [
                                    Container(
                                      height: 70.h,
                                      child: ListView.builder(
                                          itemCount: data.requests.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                              //padding:
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  border: Border.all(color: Colors.black,width: 1.0)
                                              ),
                                              child: ExpansionTile(
                                                  textColor: Colors.black,
                                                  iconColor: Colors.black,
                                                  leading: const CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundColor: Colors.greenAccent,
                                                    child: Icon(Icons.bloodtype,color: Colors.black,),
                                                  ),
                                                  title: Text(data.requests[index]["time"],style: TextStyle(fontSize: 4.w),),
                                                  subtitle: Text(data.requests[index]["requiredBlood"].toString(),style: TextStyle(fontSize: 3.w),),
                                                  children: [
                                                    data.donors.isEmpty
                                                        ? Text("No Donors Found Yet.",style: TextStyle(color: Colors.black,fontSize: 3.w,fontWeight: FontWeight.w300),)
                                                        : Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        ListTile(
                                                          title: Text("Fulfilled By :",style: TextStyle(color: Colors.black,fontSize: 3.w,fontWeight: FontWeight.w300),),
                                                          subtitle: Text(data.donors[index]["name"] + " " + data.donors[index]["phone"],style: TextStyle(color: Colors.black,fontSize: 4.w),),
                                                          trailing: Text(data.donors[index]["bloodGroup"],style: const TextStyle(color: Colors.black),),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text("Request not resolved ?",style: TextStyle(color: Colors.black,fontSize: 3.w,fontWeight: FontWeight.w300),),
                                                            SizedBox(width: 1.w),
                                                            Text("Connect with Us",style: TextStyle(color: const Color(0xFFE60026),fontSize: 3.w,fontWeight: FontWeight.w300),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 2.h,)
                                                      ],
                                                    ),
                                                  ]
                                              ),
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                              Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Text("Past Requests",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 4.w),),
                                  iconColor: Colors.black,
                                  textColor: Colors.black,
                                  children: [
                                    Container(
                                      height: 60.h,
                                      child: ListView.builder(
                                          itemCount: data.completedRequests.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                              //padding:
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  border: Border.all(color: Colors.black,width: 1.0)
                                              ),
                                              child: ExpansionTile(
                                                  textColor: Colors.black,
                                                  iconColor: Colors.black,
                                                  leading: const CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundColor: Colors.greenAccent,
                                                    child: Icon(Icons.bloodtype,color: Colors.black,),
                                                  ),
                                                  title: Text(data.completedRequests[index]["time"],style: TextStyle(fontSize: 4.w),),
                                                  subtitle: Text(data.completedRequests[index]["requiredBlood"].toString(),style: TextStyle(fontSize: 3.w),),
                                                  children: [
                                                    data.completedDonors.isEmpty
                                                        ? Text("No Donors Found Yet.",style: TextStyle(color: Colors.black,fontSize: 3.w,fontWeight: FontWeight.w300),)
                                                        : Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        ListTile(
                                                          title: Text("Fulfilled By :",style: TextStyle(color: Colors.black,fontSize: 3.w,fontWeight: FontWeight.w300),),
                                                          subtitle: Text(data.completedDonors[index]["name"] + " " + data.completedDonors[index]["phone"],style: TextStyle(color: Colors.black,fontSize: 4.w),),
                                                          trailing: Text(data.completedDonors[index]["bloodGroup"],style: const TextStyle(color: Colors.black),),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text("Request not resolved ?",style: TextStyle(color: Colors.black,fontSize: 3.w,fontWeight: FontWeight.w300),),
                                                            SizedBox(width: 1.w),
                                                            Text("Connect with Us",style: TextStyle(color: const Color(0xFFE60026),fontSize: 3.w,fontWeight: FontWeight.w300),),
                                                          ],
                                                        ),
                                                        SizedBox(height: 2.h,)
                                                      ],
                                                    ),
                                                  ]
                                              ),
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                    });
                  })),
        ));
  }
}


