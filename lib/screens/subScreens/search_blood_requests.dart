import 'package:blood_bank/providers/donor_provider.dart';
import 'package:blood_bank/screens/subScreens/see_donors.dart';
import 'package:blood_bank/screens/subScreens/see_request_history.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';

class SearchBloodRequests extends StatelessWidget {
  SearchBloodRequests({Key? key}) : super(key: key);

  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("Search Blood Requests",style: TextStyle(fontSize: 4.w,fontWeight: FontWeight.w300,color: Colors.black),),
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
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Enter the number you used to request blood !",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 4.w),textAlign: TextAlign.center,),
                SizedBox(height: 4.h,),
                TextField(
                  cursorColor: Colors.black,
                  controller: _phoneController,
                  decoration: kInputDecoration.copyWith(labelText: "Phone*"),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 4.h,),
                GestureDetector(
                  onTap: () {
                    if(_phoneController.text.isEmpty || _phoneController.text.length != 10){
                      Fluttertoast.showToast(msg: "Invalid Phone Number");
                      return ;
                    }
                    //Provider.of<Donors>(context,listen: false).checkRequestHistory(context, _phoneController.text);
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SeeRequestHistory(phone: _phoneController.text)));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Color(0xFFE60026),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Text(
                      "Search For Requests",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
