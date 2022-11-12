import 'package:blood_bank/providers/donor_provider.dart';
import 'package:blood_bank/providers/location_provider.dart';
import 'package:blood_bank/providers/request_blood_provider.dart';
import 'package:blood_bank/screens/home_Screen.dart';
import 'package:blood_bank/screens/subScreens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Sizer(
              builder: (context, orientation, deviceType) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (context) => RequestBlood()),
                  ChangeNotifierProvider(create: (context) => Locations()),
                  ChangeNotifierProvider(create: (context) => Donors()),
                ],
                child: MaterialApp(
                  title: 'HelpinBlood',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: "Poppins"),
                  home: const SplashScreen(),
                  routes: {
                    "/HomeScreen" : (context) => HomeScreen(),
                  },
                ),
              ),
            );
  }
}
