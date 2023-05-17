// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'dart:io';
// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'faceDetector.dart';
import 'package:http/http.dart' as http;

import 'jsonScreen.dart';
//required imports for html and js files

class GalleryCamera extends StatefulWidget {
  const GalleryCamera({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GalleryCameraState createState() => _GalleryCameraState();
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Loading...'),
          ],
        ),
      ),
    );
  }
}

class _GalleryCameraState extends State<GalleryCamera> {
  File? _image;

  //final ImagePicker _picker = ImagePicker();

  // Future<void> _getImage(ImageSource source) async {
  //   final pickedFile = await _picker.pickImage(source: source);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  Future<void> _uploadImage() async {
    final url =
        Uri.parse('https://python-docker-poaxpgqwua-uc.a.run.app/process');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    // Set additional headers
    request.headers.addAll({
      'Authorization': 'Bearer your_api_key_here',
      'User-Agent': 'Your App Name/Version',
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data',
      'Cache-Control': 'no-cache',
    });

    final response = await request.send();
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

      //pass jsonResponse to the next screen to display the data on the screen in a list view
      // ignore: use_build_context_synchronously
    } else {
      // Handle error response
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: ${await response.stream.bytesToString()}');
    }
  }

  Future<void> _getImage(ImageSource gallery) async {
    // ignore: deprecated_member_use
    final image = await ImagePicker()
        // ignore: deprecated_member_use
        .getImage(source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Upload CNIC Photo'),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? const Text('No image selected')
                : Image.file(_image!, height: 300),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _getImage(ImageSource.gallery);
                  },
                  // ignore: sort_child_properties_last
                  child: Row(
                    children: const [
                      Icon(Icons.camera_alt),
                      SizedBox(width: 5),
                      Text('Gallery'),
                    ],
                  ),
                  //add color to button here

                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // ignore: duplicate_ignore
        onPressed: () {
          if (_image != null) {
            // Show dialog to confirm image upload
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Upload CNIC Photo?'),
                content:
                    const Text('Are you sure you want to upload this photo?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Retake'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WillPopScope(
                                  onWillPop: () {
                                    Navigator.pop(context);
                                    Navigator.pop(
                                        context); // Navigate back to the previous screen
                                    return Future.value(
                                        true); // Prevent default behavior of back button
                                  },
                                  child: const LoadingScreen(),
                                )),
                      );
                      // Upload image to server
                      await _uploadImage();
                      // Navigator.pop(context);
                      // Navigator.pop(context);
                      // Show snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Image uploaded successfully'),
                        ),
                      );
                      //show json data on next screen
                      // ignore: use_build_context_synchronously
                    },
                    child: const Text('Upload'),
                  ),
                ],
              ),
            );
          } else {
            // Show snackbar if no image is selected
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select an image'),
              ),
            );
          }
        },
        child: const Icon(Icons.upload),
      ),
    );
  }
}
