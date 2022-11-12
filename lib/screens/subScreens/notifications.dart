import 'package:blood_bank/constants/constants.dart';
import 'package:blood_bank/providers/donor_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

bool? isChecked = false;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  List notifForUser = [];
  List ids = [];
  Future<void> checkForNotif() async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .get();
    notifForUser = result.docs;
    for (int i = 0; i < notifForUser.length; i++) {
      if (ids.contains(notifForUser[i].id)) {
        continue;
      } else {
        ids.add(notifForUser[i].id);
      }
    }
  }

  Future<void> deleteNotif() async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .get();
    final id = result.docs.firstWhere((element) => ids.contains(element.id)).id;
    if(id == ""){
      return ;
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .doc(id)
        .delete();
    setState(() {});
  }

  showModalDialog(int index) async {
    return await showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                height: 60.h,
                margin: EdgeInsets.symmetric(horizontal: 3.5.w,vertical: 2.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Lottie.asset("assets/images/succesanimation.json",height: 30.h),
                    Text(
                      "Congratulations ! You have successfully volunteered to save a life and you can connect with the victim via:",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 4.w),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${notifForUser[index]["requestedBy"]}",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 5.w),
                        ),
                        SizedBox(width: 2.w,),
                        GestureDetector(
                            onTap: (){

                            },
                            child: const Icon(Icons.phone,color: Colors.black,)),
                      ],
                    )

                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: SafeArea(
            child: Container(
          height: 90.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  child: Text(
                    "Notifications",
                    style:
                        TextStyle(fontSize: 5.w, fontWeight: FontWeight.w400),
                  )),
              FutureBuilder(
                  future: checkForNotif(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ));
                    }
                    return Container(
                        height: 75.h,
                        width: 95.h,
                        child: notifForUser.isEmpty
                            ? Center(
                                child: Text(
                                  "No Blood Requests in your area.",
                                  style: TextStyle(
                                      fontSize: 4.w,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : ListView.builder(
                                itemCount: notifForUser.length,
                                itemBuilder: (context, index) {
                                  String requestBlood = "";
                                  notifForUser[index]["requiredBlood"]
                                      .forEach((element) {
                                    requestBlood += element + " ";
                                  });
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.h),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0.5.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: ListTile(
                                      title: Text(
                                        "There is a request for $requestBlood blood near you! Be a helpIn hero at the time of need",
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 3.w,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      trailing: SizedBox(
                                        width: 25.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (context) => Dialog(
                                                                child:
                                                                    Container(
                                                                  width: 80.w,
                                                                  height: 70.h,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          2.w,
                                                                      vertical:
                                                                          1.h),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Text(
                                                                        "Self Declaration",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                4.w,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                      Text(
                                                                        "We appreciate your effort to save one life. But before, you can actually donate blood, you "
                                                                        "need to be eligible for donating blodd.\n"
                                                                        "By signing this declaration you accept that \n"
                                                                        "- In the past 3 months, you haven't been injected with Drugs, Steroids or any other non prescribed substance \n"
                                                                        "- You are not affected with congenital coagulation factor deficiency \n"
                                                                        "- You haven't tested positive for HIV \n"
                                                                        "- You haven't been in close/sexual contact with any person having hepatitis \n"
                                                                        "- You havent consumed alchohols, tobacco, cigarettes in past 12-24 hours \n",
                                                                        softWrap:
                                                                            true,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                3.w,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          CheckboxDeclaration(),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              "I, hereby decalre that I have read all the required laws and ready to donate blood.",
                                                                              softWrap: true,
                                                                              style: TextStyle(fontSize: 3.w, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          if (isChecked ==
                                                                              false) {
                                                                            Fluttertoast.showToast(msg: "Please sign the declaration.");
                                                                            return;
                                                                          }
                                                                          QuerySnapshot
                                                                              result =
                                                                              await FirebaseFirestore.instance.collection("bloodRequests").get();
                                                                          final docId = result.docs.firstWhere((element) =>
                                                                              element["requestedBy"] ==
                                                                              notifForUser[index]["requestedBy"]).id;
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection("bloodRequests")
                                                                              .doc(docId)
                                                                              .collection("approvedUsers")
                                                                              .add({
                                                                            "userId":
                                                                                userId,
                                                                          });
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection("bloodRequests")
                                                                              .doc(docId)
                                                                              .update({
                                                                            "isFulfilled":
                                                                            true,
                                                                          });
                                                                          await showModalDialog(index);
                                                                          await deleteNotif();
                                                                          Navigator.popUntil(
                                                                              context,
                                                                              (route) => route.isFirst);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 3.w,
                                                                              vertical: 1.h),
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Color(0xFF7209b7),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            "Accept",
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 3.w),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ));
                                                },
                                                child: const Icon(
                                                  Icons.done,
                                                  color: Colors.green,
                                                )),
                                            GestureDetector(
                                              onTap: () async {
                                                await deleteNotif();
                                              },
                                              child: const Icon(
                                                Icons.clear,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }));
                  }),
            ],
          ),
        )));
  }
}

class CheckboxDeclaration extends StatefulWidget {
  const CheckboxDeclaration({Key? key}) : super(key: key);

  @override
  State<CheckboxDeclaration> createState() => _CheckboxDeclarationState();
}

class _CheckboxDeclarationState extends State<CheckboxDeclaration> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.all(Color(0xFF7209b7)),
      onChanged: (bool? val) {
        print(isChecked);
        setState(() {
          isChecked = val!;
        });
      },
    );
  }
}
