import 'dart:io';
import 'package:blood_bank/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../constants/constants.dart';

class DonorRegForm extends StatefulWidget {
  final String name;
  final String bloodGroup;
  final String age;
  final String phoneNumber;
  final String email;
  const DonorRegForm({
    Key? key,
    required this.name,
    required this.bloodGroup,
    required this.phoneNumber,
    required this.email,
    required this.age,
  }) : super(key: key);

  @override
  State<DonorRegForm> createState() => _DonorRegFormState();
}

class _DonorRegFormState extends State<DonorRegForm> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? id;
  File? testReport;
  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ["pdf"], type: FileType.custom);

    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    } else {
      Fluttertoast.showToast(
          msg: "No File Picked",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 3.w);
      return null;
    }
  }

  Future<void> createUser(
      String name,
      String email,
      String phone,
      String age,
      String bloodGroup,
      String city,
      String state,
      String pincode,
      File id,
      File report) async {
    setState((){
      _isLoading = true;
    });
    try {
      User? _authResult = await AuthState().userRegister(email, phone);
      final ref = FirebaseStorage.instance
          .ref()
          .child('ids')
          .child('${widget.name}-id.pdf');
      await ref.putFile(id);
      final idUrl = await ref.getDownloadURL();
      final ref1 = FirebaseStorage.instance
          .ref()
          .child('reports')
          .child('${widget.name}-report.pdf');
      await ref1.putFile(report);
      final reportUrl = await ref1.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_authResult!.uid)
          .set({
        "name": name,
        "email": email,
        "phone": phone,
        "bloodGroup": bloodGroup,
        "age": age,
        "address": '$city , $state , $pincode',
        "idUrl": idUrl,
        "reportUrl": reportUrl,
        "isValid" : false,
      });
      setState((){
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      var message = "An Error Occurred ! Please Try Again.";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState((){
        _isLoading = false;
      });
    } catch (e){
      print(e);
      setState((){
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  child: Text(
                    "Just Few More Steps",
                    style:
                        TextStyle(fontSize: 5.w, fontWeight: FontWeight.w400),
                  )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextFormField(
                                cursorColor: Colors.black,
                                controller: _cityController,
                                decoration: kInputDecoration.copyWith(
                                    labelText: "City*"),
                                validator: (value) {
                                  if (_cityController.text.isEmpty ||
                                      value == null) {
                                    return "Please Fill a City";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Expanded(
                              child: TextFormField(
                                cursorColor: Colors.black,
                                controller: _stateController,
                                decoration: kInputDecoration.copyWith(
                                    labelText: "State*"),
                                validator: (value) {
                                  if (_stateController.text.isEmpty ||
                                      value == null) {
                                    return "Please Fill a State";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        kSizedBox,
                        TextFormField(
                          cursorColor: Colors.black,
                          controller: _pincodeController,
                          decoration:
                              kInputDecoration.copyWith(labelText: "Pincode*"),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (_pincodeController.text.isEmpty ||
                                value == null) {
                              return "Please Fill a Valid Pincode";
                            }
                            return null;
                          },
                        ),
                        kSizedBox,
                        Text(
                          "Upload your ID Proof !",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 4.w,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "For maintaining Integrity of donors, we require to verify our donors as valid individuals\n"
                          "- Preffered file type: .pdf\n",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 3.w,
                              fontWeight: FontWeight.w300),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final idFile = await pickFile();
                            if (idFile == null) {
                              Fluttertoast.showToast(
                                  msg: "No File Picked",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 3.w);
                              return;
                            } else {
                              setState(() {
                                id = idFile;
                              });
                            }
                          },
                          child: id == null
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "Upload ID",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : Text(
                                  id!.path.split('/')[7],
                                  style: TextStyle(
                                      fontSize: 3.w,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis),
                                ),
                        ),
                        kSizedBox,
                        Text(
                          "Upload your Blood Test Report !",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 4.w,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "For faster acceptance, your blood test report should contain: \n"
                          "- Name and Age \n"
                          "- Haemoglobin and Blood Pressure \n"
                          "- Tests of HIV, Hepatitis A, Hepatitis B and Syphilis \n"
                          "- Accredited Physicians / Path Labs / Doctor's Seal\n"
                          "- Preffered file type: .pdf\n",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 3.w,
                              fontWeight: FontWeight.w300),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final testreportFile = await pickFile();
                            if (testreportFile == null) {
                              Fluttertoast.showToast(
                                  msg: "No File Picked",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 3.w);
                              return;
                            } else {
                              setState(() {
                                testReport = testreportFile;
                              });
                            }
                          },
                          child: testReport == null
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "Add File",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : Text(
                                  testReport!.path.split('/')[7],
                                  style: TextStyle(
                                      fontSize: 3.w,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis),
                                ),
                        ),
                        kSizedBox,
                        Align(
                          alignment: Alignment.center,
                          child: Hero(
                            tag: "Buttons",
                            child: _isLoading
                              ? SpinKitThreeBounce(color: const Color(0xFF7209b7))
                              : GestureDetector(
                              onTap: () async{
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate() &&
                                    id != null &&
                                    testReport != null) {
                                  _formKey.currentState!.save();
                                  await createUser(
                                      widget.name,
                                      widget.email,
                                      widget.phoneNumber,
                                      widget.age,
                                      widget.bloodGroup,
                                      _cityController.text,
                                      _stateController.text,
                                      _pincodeController.text,
                                      id!,
                                      testReport!);
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => WillPopScope(
                                        onWillPop: () async => false,
                                        child: Dialog(
                                          child: Container(
                                            width: 50.w,
                                            height: 70.h,
                                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Lottie.asset(
                                                    "assets/images/succesanimation.json",width: 50.w,height: 40.h),
                                                Text(
                                                  "Your account has been submitted for review. "
                                                      "We will notify you once your profile is verified !",
                                                  textAlign: TextAlign.center,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontSize: 4.w,
                                                      fontWeight:
                                                      FontWeight.w300),
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 3.w, vertical: 1.h),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF7209b7),
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    child: Text("Close",textAlign: TextAlign.center,style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                    ),),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                                }
                                else {
                                  Fluttertoast.showToast(
                                      msg: "Please Fill all Fields.",
                                      backgroundColor: Colors.redAccent,
                                      textColor: Colors.white);
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 8.w,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 5.w,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        kSizedBox,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
