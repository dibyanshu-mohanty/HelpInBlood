import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../providers/donor_provider.dart';
import '../../providers/request_blood_provider.dart';
class SeeDonorScreen extends StatefulWidget {
  final String phone;
  const SeeDonorScreen({Key? key,required this.phone}) : super(key: key);

  @override
  State<SeeDonorScreen> createState() => _SeeDonorScreenState();
}

class _SeeDonorScreenState extends State<SeeDonorScreen> {

  @override
  Widget build(BuildContext context) {
    final bg = Provider.of<RequestBlood>(context, listen: false).bloods;
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
          child: FutureBuilder(
            future: Provider.of<Donors>(context,listen: false).submitData(context,widget.phone,bg),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset("assets/images/search-users.json"),
                        Text(
                          "Please be patient ! We are connecting you with our read to help heroes."
                              "\n Please ensure that the patient gets to the hospital incase of an accident",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 4.w, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Lottie.asset("assets/images/succesanimation.json"),
                      Text(
                        "Your request has been sent. Please be patient ! We are connecting you with our read to help heroes."
                            "\n You can check the details of potential donors on your requests history page",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 4.w, fontWeight: FontWeight.w300),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.popUntil(context,(route) => route.isFirst);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Color(0xFF7209b7),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Text(
                            "Done",
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
                );
          }),
        )
    );
  }
}
