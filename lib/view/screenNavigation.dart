import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'jsonScreen.dart';

class ScreenContainer extends StatefulWidget {
  const ScreenContainer({Key? key}) : super(key: key);

  @override
  _ScreenContainerState createState() => _ScreenContainerState();
}

class _ScreenContainerState extends State<ScreenContainer> {
  late ImagePicker _imagePicker;
  XFile? _selectedImage;
  bool _isImageSelected = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Future<void> _selectImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _isImageSelected = true;
      });
    }
  }

  Future<void> _uploadImage() async {
    setState(() {
      _isUploading = true;
    });
    final url =
        Uri.parse('https://python-docker-poaxpgqwua-uc.a.run.app/process');
    final request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath('image', _selectedImage!.path));
    // Set additional headers
    request.headers.addAll({
      'Authorization': 'Bearer your_api_key_here',
      'User-Agent': 'Your App Name/Version',
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
      'Cache-Control': 'no-cache',
    });
    print('Sending request: $request');

    final response = await request.send();
    print('Response: $response');
    if (response.statusCode == 200) {
      // Decode the JSON response
      try {
        Map<String, dynamic> jsonResponse =
            json.decode(await response.stream.bytesToString());

        // Print the JSON response on the console
        print(jsonResponse);
        // create a new local variable and assign jsonResponse to it
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  JsonScreen(jsonData: jsonEncode(jsonResponse))),
        );
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      // Handle error response
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: ${await response.stream.bytesToString()}');
    }

    setState(() {
      _isUploading = false;
    });
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
            const Positioned(
              top: 50.0,
              left: 130.0,
              child: Text(
                'Intekhab',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            PageView(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 100.0),
                    padding: const EdgeInsets.all(23.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Verification Process',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'We need to collect your data for verification purposes. This is a one-time process. Please provide a clear and cropped image of your CNIC for verification purposes.',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 50),
                        InkWell(
                          onTap: _selectImage,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1.3,
                            height:
                                MediaQuery.of(context).size.width * 0.5 * 1.5,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_isImageSelected)
                                  Image.file(
                                    File(_selectedImage!.path),
                                    height: MediaQuery.of(context).size.width *
                                        0.5 *
                                        1.6,
                                    width: MediaQuery.of(context).size.width *
                                        0.9, // Update the width value
                                    fit: BoxFit
                                        .fill, // Set the fit property to BoxFit.fill
                                  )
                                else
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 72.0,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'Select a Cropped Image of Your CNIC from Gallery',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 50.0),
                        ElevatedButton(
                          onPressed: () => _selectImage(),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            primary: const Color(0xFFED8B30),
                            onPrimary: const Color(0xFF000000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Select CNIC',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _isImageSelected ? _uploadImage : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            primary: const Color(0xFFED8B30),
                            onPrimary: const Color(0xFF000000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (_isUploading)
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              if (!_isUploading)
                                const Text(
                                  'Upload Now',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
