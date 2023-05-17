import 'dart:convert';

import 'package:flutter/material.dart';

import 'home.dart';

class PersonDataScreen extends StatelessWidget {
  final String personData;
  final Map<String, dynamic> matchResult;
  final String? hash;

  const PersonDataScreen({
    Key? key,
    required this.personData,
    required this.matchResult,
    required this.hash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decode = jsonDecode(personData);
    final String cnic = decode['CNIC'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Person Data'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                decode['Name'],
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'CNIC Number',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cnic,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Verification Result',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    matchResult['compare'] == true
                        ? Icons.check_circle_outline
                        : Icons.highlight_off_outlined,
                    color: matchResult['compare'] == true
                        ? Colors.green
                        : Colors.red,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    matchResult['compare'] == true ? 'Matched' : 'Not Matched',
                    style: TextStyle(
                      fontSize: 24,
                      color: matchResult['compare'] == true
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Hash',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hash!,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LandingPage(
                          //name: decode['Name'],
                          cnic: cnic,
                          matchResult: matchResult,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    'Verified',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
