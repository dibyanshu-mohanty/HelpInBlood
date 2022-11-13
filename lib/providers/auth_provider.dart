import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthState {
  Future<User?> userRegister(String email, String password) async {
    final User? user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
            .catchError((e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white);
    }))
        .user;
    return user;
  }

  Future<User?> userLogin(String email, String password) async {
    final User? user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
            .catchError((e) {
      Fluttertoast.showToast(
          msg: "Please check network / credentials !",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white);
    }))
        .user;
    return user;
  }
}
