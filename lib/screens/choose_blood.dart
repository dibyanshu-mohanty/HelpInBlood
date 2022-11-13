import 'package:blood_bank/constants/constants.dart';
import 'package:blood_bank/screens/subScreens/see_donors.dart';
import 'package:blood_bank/widgets/blood_group_choose.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../providers/request_blood_provider.dart';

class ChooseBlood extends StatefulWidget {
  const ChooseBlood({Key? key}) : super(key: key);

  @override
  State<ChooseBlood> createState() => _ChooseBloodState();
}

class _ChooseBloodState extends State<ChooseBlood> {

  final TextEditingController _phoneController = TextEditingController();
  @override
  void dispose(){
    super.dispose();
    _phoneController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          title: Text("Request Blood",style: TextStyle(fontSize: 4.w,fontWeight: FontWeight.w300,color: Colors.black),),
          leading: GestureDetector(
            onTap: () {
              Provider.of<RequestBlood>(context, listen: false).emptyBloodList();
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SafeArea(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            children: [
              SizedBox(
                width: 80.w,
                height: 40.h,
                child: Image.asset("assets/images/search_blood.jpg"),
              ),
              Text(
                "Request Blood !",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 7.w,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "Send a blood request to all helpIn Heroes nearby you !",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 4.w,
                    fontWeight: FontWeight.w400),
              ),
              kSizedBox,
              Text(
                "Choose Required blood type",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 4.w,
                    fontWeight: FontWeight.w100),
              ),
              kSizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  ChooseBloodGroup(title: "A+"),
                   ChooseBloodGroup(title: "A-"),
                   ChooseBloodGroup(title: "B+"),
                   ChooseBloodGroup(title: "B-"),
                ],
              ),
              kSizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  ChooseBloodGroup(title: "O+"),
                  ChooseBloodGroup(title: "O-"),
                  ChooseBloodGroup(title: "AB+"),
                  ChooseBloodGroup(title: "AB-"),
                ],
              ),
              kSizedBox,
              TextField(
                cursorColor: Colors.black,
                controller: _phoneController,
                decoration: kInputDecoration.copyWith(labelText: "Phone*"),
                keyboardType: TextInputType.number,
              ),
              kSizedBox,
              GestureDetector(
                onTap: () {
                  //Provider.of<RequestBlood>(context, listen: false).emptyBloodList();
                  final bg = Provider.of<RequestBlood>(context, listen: false).bloods;
                  if (bg.isEmpty) {
                    Fluttertoast.showToast(msg: "Please pick atleast one blood group",backgroundColor: Colors.black,textColor: Colors.white);
                    return ;
                  }
                  if(_phoneController.text.isEmpty){
                    Fluttertoast.showToast(msg: "Please Enter Phone");
                    return ;
                  }
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SeeDonorScreen(phone: _phoneController.text)));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xFFE60026),
                      Color(0xFFbc0a3c),
                    ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Text(
                    "Request Blood",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              kSizedBox,
            ],
          ),
        )));
  }
}
