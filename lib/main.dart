import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:evm_app/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyLogin(title: 'EVM'),
      routes: {
        'register': (context) => const MyRegister(),
        'login': (context) => const MyLogin(title: 'EVM'),
        // 'landingpage': (context) => const landingpage(),
        //'MyHomePage': (context) => const MyHomePage(title: 'Home'),
      },
    );
  }
}
