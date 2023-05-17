// ignore_for_file: use_build_context_synchronously, deprecated_member_use, file_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, non_constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'package:evm_app/personData.dart';
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

  String hashCNIC(String cnic, DateTime time) {
    // Concatenate the CNIC number, name, and time into a single string
    String input = cnic + time.toString();

    // Hash the input string using SHA-256
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);

    // Encode the digest as a base64 string and take the first 6 characters
    String hash = base64Url.encode(digest.bytes).substring(0, 6);

    // Return the 6-digit alphanumeric hash
    return hash;
  }

  Future<String?> _callHashAPI() async {
    final decode = jsonDecode(widget.persondata);
    final cnic = int.tryParse(decode['CNIC'].toString().replaceAll('-', ''));
    final hash_gen = hashCNIC(cnic.toString(), DateTime.now());

    //hash API call
    final hash_url = 'https://face-live-hash-we4eecg66a-uc.a.run.app/hash';
    final headers = {'Content-type': 'application/json'};
    final body = {'cnic': cnic.toString(), 'hash': hash_gen};
    final hash_response = await http.post(Uri.parse(hash_url),
        headers: headers, body: jsonEncode(body));

    print('Response status code: ${hash_response.statusCode}');
    print('Response datatype of hash: ${hash_response.body.toString()}');
    if (hash_response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(hash_response.body);
      final String hashResult = data['hash'].toString();
      return hash_gen;
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Failed to hash the cnic. Please try again later.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      return null;
    }
  }

  void _callAPI() async {
    setState(() {
      _isLoading = true;
    });

    final decode = jsonDecode(widget.persondata);
    final cnic = int.tryParse(decode['CNIC'].toString().replaceAll('-', ''));

    //face match API call
    final url = 'https://face-live-hash-we4eecg66a-uc.a.run.app/process';
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['cnic_number'] = cnic.toString()
      ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

    print("Sending request to $url with cnic: $cnic and image: $_image");
    final response = await http.Response.fromStream(await request.send());
    print("Process: $response.body");
    print('Response status code: ${response.statusCode}');

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      String data = utf8.decode(response.bodyBytes);
      Map<String, dynamic> matchResult = json.decode(data);
      //bool matchResult = data.contains('true');
      //bool matchResult = data['match'];
      print('Match result: $matchResult');

      if (matchResult['compare'] == true &&
          matchResult['liveliness'] == false) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Face matched successfully!'),
            backgroundColor: Colors.green, // Customize the snackbar appearance
            action: SnackBarAction(
              label: 'Ok',
              textColor: Colors.white,
              onPressed: () async {
                String? hashRes = await _callHashAPI();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonDataScreen(
                      personData: widget.persondata,
                      matchResult: matchResult,
                      hash: hashRes,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to match the face. Please try again.'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Close',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
      // Do something with the matchResult
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Failed to match the face. Please try again later.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Check Liveliness',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _image == null
                        ? Center(
                            child: Text(
                              'Please select an image',
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
                    primary: Colors.blue,
                    backgroundColor:
                        Colors.white, // <-- set background color here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Take a photo',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _image == null ? null : () => _callAPI(),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Change the color to red
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    _image == null ? 'Detect Face (Disabled)' : 'Detect Face',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
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
    );
  }
}
