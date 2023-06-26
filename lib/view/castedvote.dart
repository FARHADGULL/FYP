import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CastedVote extends StatelessWidget {
  const CastedVote({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3CA75D),
                  Color(0xFF0A4F27),
                ],
                stops: [0, 1],
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/images/pak.svg', // Replace with your SVG image file path
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
          const Center(
            child: Text(
              'Thank You For Voting!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Positioned(
            top: 50.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Intekhab',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 15,
            right: 15,
            child: ElevatedButton(
              onPressed: () {
                Get.offAllNamed('/');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                primary: const Color(0xFFFFFFFF),
                onPrimary: const Color(0xFF000000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Back To Home',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A4F27),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
