import 'package:blood_bank/constants/constants.dart';
import 'package:blood_bank/widgets/donor_file_upload.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DonorRegistrationForm extends StatefulWidget {
  const DonorRegistrationForm({Key? key}) : super(key: key);

  @override
  State<DonorRegistrationForm> createState() => _DonorRegistrationFormState();
}

class _DonorRegistrationFormState extends State<DonorRegistrationForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w,vertical: 7.h),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              cursorColor: Colors.black,
              controller: _nameController,
              decoration: kInputDecoration.copyWith(labelText: "Name*"),
              validator: (value){
                if(_nameController.text.isEmpty || value == null){
                  return "Please Fill a Valid Name";
                }
                return null;
              },
            ),
            kSizedBox,
            TextFormField(
                cursorColor: Colors.black,
                controller: _bloodGroupController,
                decoration: kInputDecoration.copyWith(labelText: "Blood Group*"),
                validator: (value){
                  if(_bloodGroupController.text.isEmpty || value == null){
                    return "Please Fill a Valid Blood Group";
                  }
                  return null;
                },
            ),
            kSizedBox,
            TextFormField(
                cursorColor: Colors.black,
                controller: _ageController,
                decoration: kInputDecoration.copyWith(labelText: "Age*"),
              keyboardType: TextInputType.number,
              validator: (value){
                if(_ageController.text.isEmpty || value == null){
                  return "Please Fill a Valid Age";
                }
                return null;
              },
            ),
            kSizedBox,
            TextFormField(
                cursorColor: Colors.black,
                controller: _phoneController,
                decoration: kInputDecoration.copyWith(labelText: "Phone*"),
                keyboardType: TextInputType.number,
              validator: (value){
                if(_phoneController.text.isEmpty || value == null){
                  return "Please Fill a Valid Phone Number";
                }
                return null;
              },
            ),
            kSizedBox,
            TextFormField(
                cursorColor: Colors.black,
                controller: _emailController,
                decoration: kInputDecoration.copyWith(labelText: "Email*"),
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if(_emailController.text.isEmpty || value == null || !_emailController.text.contains('@')){
                  return "Please Fill a Valid Email";
                }
                return null;
              },
            ),
            kSizedBox,
            Hero(
              tag: "Buttons",
              child: GestureDetector(
                onTap: (){
                  FocusScope.of(context).unfocus();
                  if(_formKey.currentState!.validate()){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DonorRegForm(
                      name: _nameController.text,
                      bloodGroup: _bloodGroupController.text,
                      age: _ageController.text,
                      phoneNumber: _phoneController.text,
                      email: _emailController.text,
                    )));
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 8.w,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 5.w,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
