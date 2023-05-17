// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'faceDetector.dart';

class JsonScreen extends StatelessWidget {
  final String jsonData;

  const JsonScreen({Key? key, required this.jsonData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decodedData = jsonDecode(jsonData);
    // final cnic =
    //     int.tryParse(decodedData['CNIC'].toString().replaceAll('-', ''));

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('JSON Data'),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80.0),
              const Text(
                "If your CNIC data is correct, press 'Continue' to proceed to face detection",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(56.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Name:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          decodedData['Name'],
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'Father Name:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          decodedData['Father Name'],
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'CNIC:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          decodedData['CNIC'],
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'Date of Birth:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          decodedData['Date of Birth'],
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'Date of Issue:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          decodedData['Date of Issue'],
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'Date of Expiry:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          decodedData['Date of Expiry'],
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                        final cnic = int.tryParse(
                            decodedData['CNIC'].toString().replaceAll('-', ''));
                        final url =
                            'https://face-live-hash-we4eecg66a-uc.a.run.app/match';
                        print(
                            'Sending request to $url with body: {cnic: $cnic}');
                        final headers = {'Content-Type': 'application/json'};
                        final response = await http.post(Uri.parse(url),
                            headers: headers,
                            body: json.encode({'cnic': cnic.toString()}));
                        print('Response status code: ${response.statusCode}');
                        Navigator.pop(context); // Remove loading indicator
                        if (response.statusCode == 200) {
                          final data = jsonDecode(response.body);
                          final matchResult = data['match'];
                          print('Match result: $matchResult');

                          if (matchResult == true) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('CNIC number found'),
                                  content: const Text(
                                      'The CNIC number you entered is found in our database'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FaceDetectionScreen(
                                                    persondata: jsonEncode(
                                                        decodedData)),
                                          ),
                                        );
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('CNIC number not found')));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Error: Failed to fetch data')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: const Text('Continue',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ),
                      ),
                      child: const Text('Retake',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      //when user clicks on back button of phone then it should go back to the previous screen
      // body: WillPopScope(
      //   onWillPop: () async {
      //     Navigator.pop(context);
      //     Navigator.pop(context);
      //     Navigator.pop(context);
      //     return true;
      //   },
    );
  }
}
