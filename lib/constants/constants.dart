
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

final kInputDecoration = InputDecoration(
    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(10.0)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(10.0)),
    labelText: "Name*",
    labelStyle: TextStyle(color: Colors.black)
);

final kSizedBox = SizedBox(height: 3.5.h,);
final mkSizedBox = SizedBox(height: 10.h,);