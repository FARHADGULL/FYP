import 'package:Intekhab/view/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/login.dart';

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
      //home: const MyLogin(title: 'EVM'),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: 'login',
      routes: {
        'register': (context) => const MyRegister(),
        'login': (context) => const MyLogin(title: 'EVM'),
      },
    );
  }
}
