import 'package:blood_bank/screens/subScreens/accepted_request_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    if (id == "") {
      return;
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .doc(id)
        .delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
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
          child: FutureBuilder(
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
                                  fontSize: 4.w, fontWeight: FontWeight.w500),
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
                                    borderRadius: BorderRadius.circular(10.0)),
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
                                                  builder: (context) => Dialog(
                                                        child: Container(
                                                          width: 80.w,
                                                          height: 70.h,
                                                          padding: EdgeInsets
                                                              .symmetric(
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
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
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
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        3.w,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  CheckboxDeclaration(),
                                                                  Expanded(
                                                                    child: Text(
                                                                      "I, hereby decalre that I have read all the required laws and ready to donate blood.",
                                                                      softWrap:
                                                                          true,
                                                                      style: TextStyle(
                                                                          fontSize: 3
                                                                              .w,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  if (isChecked ==
                                                                      false) {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "Please sign the declaration.");
                                                                    return;
                                                                  }
                                                                  QuerySnapshot
                                                                      result =
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "bloodRequests")
                                                                          .get();
                                                                  final docId = result
                                                                      .docs
                                                                      .firstWhere((element) =>
                                                                          element[
                                                                              "requestedBy"] ==
                                                                          notifForUser[index]
                                                                              [
                                                                              "requestedBy"])
                                                                      .id;
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "bloodRequests")
                                                                      .doc(
                                                                          docId)
                                                                      .collection(
                                                                          "approvedUsers")
                                                                      .add({
                                                                    "userId":
                                                                        userId,
                                                                  });
                                                                  await deleteNotif();
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => AcceptedRequestScreen(
                                                                              phNo: notifForUser[index]["requestedBy"],
                                                                              position: notifForUser[index]["location"])));
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          3.w,
                                                                      vertical:
                                                                          1.h),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFF7209b7),
                                                                  ),
                                                                  child: Text(
                                                                    "Accept",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            3.w),
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
