import 'package:blood_bank/widgets/donor_registration_form.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DonorRegistration extends StatefulWidget {
  const DonorRegistration({Key? key}) : super(key: key);

  @override
  State<DonorRegistration> createState() => _DonorRegistrationState();
}

class _DonorRegistrationState extends State<DonorRegistration> with SingleTickerProviderStateMixin{
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
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: SafeArea(
            child: SizedBox(
              height: 100.h,
              width: 100.w,
              child: ListView(
          children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                  child: Text("Complete Your Donor Profile",style: TextStyle(fontSize: 5.w,fontWeight: FontWeight.w400),)),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                "There is no greater deed than saving lives.",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 3.w,
                    fontWeight: FontWeight.w300),
              ),
            ),
              DonorRegistrationForm(),
          ],
        ),
            )));
  }
}
