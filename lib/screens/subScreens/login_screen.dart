import 'package:blood_bank/providers/auth_provider.dart';
import 'package:blood_bank/screens/home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
      ),
        body: Form(
          key: _formKey,
          child: Container(
            width: 100.w,
            height: 80.h,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Login as a helpIn Donor",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 5.w,
                      fontWeight:
                      FontWeight.w400),
                ),
                TextFormField(
                  controller: _emailController,
                  cursorColor: Colors.black,
                  decoration: kInputDecoration.copyWith(labelText: "Email*"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (_){
                    if(_emailController.text.isEmpty || !_emailController.text.contains('@')){
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  cursorColor: Colors.black,
                  decoration: kInputDecoration.copyWith(labelText: "Phone*"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (_){
                    if(_phoneController.text.isEmpty || _phoneController.text.length != 10){
                      return "Please enter a valid phone number";
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: () async{
                    // Navigator.of(context).popUntil((route) => route.isFirst);
                    if(_formKey.currentState!.validate()){
                      await AuthState().userLogin(_emailController.text.trim(), _phoneController.text.trim());
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong.",style: TextStyle(fontWeight: FontWeight.w400),),backgroundColor: Colors.deepOrangeAccent,));
                      return ;
                    }

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 3.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Color(0xFFE60026),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text("Login",textAlign: TextAlign.center,style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
