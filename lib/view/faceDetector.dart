// ignore_for_file: use_build_context_synchronously, deprecated_member_use, file_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, non_constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'package:Intekhab/view/personData.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class FaceDetectionScreen extends StatefulWidget {
  final String persondata;
  //final String hash;

  const FaceDetectionScreen({Key? key, required this.persondata})
      : super(key: key);

  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  File? _image;
  bool _isLoading = false;

  //add a getter here for the hash
  //Future<String?> Function(int cnic) get hashResult_Value => _callHashAPI;

  Future<void> _getImageFromCamera(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  String hashCNIC(String cnic) {
    // Concatenate the CNIC number, name, and time into a single string
    String input = cnic;

    // Hash the input string using SHA-256
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);

    // Encode the digest as a base64 string and take the first 6 characters
    String hash = base64Url.encode(digest.bytes).substring(0, 6);

    // Return the 6-digit alphanumeric hash
    return hash;
  }

  // Future<String?> _callHashAPI() async {
  //   final decode = jsonDecode(widget.persondata);
  //   final cnic = int.tryParse(decode['CNIC'].toString().replaceAll('-', ''));
  //   final hash_gen = hashCNIC(cnic.toString());

  //   //hash API call
  //   final hash_url = 'https://face-live-hash-we4eecg66a-uc.a.run.app/hash';
  //   final headers = {'Content-type': 'application/json'};
  //   final body = {'cnic': cnic.toString(), 'hash': hash_gen};
  //   final hash_response = await http.post(Uri.parse(hash_url),
  //       headers: headers, body: jsonEncode(body));

  //   print('Response status code: ${hash_response.statusCode}');
  //   print('Response datatype of hash: ${hash_response.body.toString()}');
  //   if (hash_response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(hash_response.body);
  //     final String hashResult = data['hash'].toString();
  //     return hash_gen;
  //   } else {
  //     // Show an error message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content:
  //             const Text('Failed to hash the cnic. Please try again later.'),
  //         backgroundColor: Colors.red,
  //         action: SnackBarAction(
  //           label: 'Close',
  //           textColor: Colors.white,
  //           onPressed: () {
  //             ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //           },
  //         ),
  //       ),
  //     );
  //     return null;
  //   }
  // }

  void _callAPI() async {
    setState(() {
      _isLoading = true;
    });

    final decode = jsonDecode(widget.persondata);
    final cnic = int.tryParse(decode['CNIC'].toString().replaceAll('-', ''));

    //face compare API call
    final url = 'https://face-live-hash-we4eecg66a-uc.a.run.app/process';
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['cnic_number'] = cnic.toString()
      ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

    print(
        "Sending compare request to $url with cnic: $cnic and image: $_image");
    final response = await http.Response.fromStream(await request.send());
    print("Process: $response.body");
    print('Response status code: ${response.statusCode}');

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      String data = utf8.decode(response.bodyBytes);
      Map<String, dynamic> matchResult = json.decode(data);
      print('Match result: $matchResult');

      if (matchResult['compare'] == true) {
        setState(() {
          _isLoading = true;
        });
        //face liveness API call
        final url = 'https://liveness-3i5n3xlatq-uc.a.run.app/process';
        final request = http.MultipartRequest('POST', Uri.parse(url))
          // ..fields['cnic_number'] = cnic.toString()
          ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

        print("Sending Liveness request to $url with image: $_image");
        final response = await http.Response.fromStream(await request.send());
        print("Process: $response.body");
        print('Response status code: ${response.statusCode}');

        setState(() {
          _isLoading = false;
        });
        if (response.statusCode == 200) {
          String data = utf8.decode(response.bodyBytes);
          Map<String, dynamic> matchResult = json.decode(data);
          print('Liveness result: $matchResult');
          if (matchResult['liveness'] == true) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Liveness checked successfully!'),
                  content: const Text('Click continue to proceed.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        final cnic = int.tryParse(
                            decode['CNIC'].toString().replaceAll('-', ''));
                        final hash_gen = hashCNIC(cnic.toString());
                        //String? hashRes = await _callHashAPI();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonDataScreen(
                              personData: widget.persondata,
                              matchResult: matchResult,
                              hash: hash_gen,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                        primary: const Color(0xFFED8B30),
                        onPrimary: const Color(0xFF000000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Face is not live.'),
                  content: const Text('Please try again later.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                        primary: const Color.fromARGB(255, 209, 34, 34),
                        onPrimary: const Color(0xFF000000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Failed to detect the Live face'),
                content: const Text('Please try again.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      primary: const Color.fromARGB(255, 209, 34, 34),
                      onPrimary: const Color(0xFF000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Face is not matched.'),
              content: const Text('Take a clear image please.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    primary: const Color.fromARGB(255, 209, 34, 34),
                    onPrimary: const Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Failed to compare the face'),
            content: const Text('Please try again.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  primary: const Color.fromARGB(255, 209, 34, 34),
                  onPrimary: const Color(0xFF000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
      child: Stack(
        children: [
          Center(
              child: Container(
            margin: const EdgeInsets.only(top: 100.0),
            padding: const EdgeInsets.all(30.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Liveliness',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _image == null
                        ? Center(
                            child: Text(
                              'Please Capture a Photo',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16.0,
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _getImageFromCamera(ImageSource.camera),
                  style: ElevatedButton.styleFrom(
                    //strecth the button to full width
                    minimumSize: const Size(double.infinity, 50),
                    primary: const Color(0xFFED8B30),
                    onPrimary: const Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Take photo',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _image == null ? null : () => _callAPI(),
                  style: ElevatedButton.styleFrom(
                    //strecth the button to full width
                    minimumSize: const Size(double.infinity, 50),
                    primary: const Color(0xFFED8B30),
                    onPrimary: const Color(0xFF000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    _image == null ? 'Detect Face (Disabled)' : 'Detect Face',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (_image == null) const SizedBox(height: 8.0),
                if (_image == null)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Please take a photo first to detect face.',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )),
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
          _isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    ));
  }
}
