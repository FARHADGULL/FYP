// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'gallery_camera.dart';

class ScreenContainer extends StatefulWidget {
  const ScreenContainer({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ScreenContainerState createState() => _ScreenContainerState();
}

class _ScreenContainerState extends State<ScreenContainer> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void _onPageChanged(int pageIndex) {
    setState(() {
      _currentPage = pageIndex;
    });
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ignore: prefer_const_constructors
                    Text(
                      'Verification Required',
                      style: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        'We need to collect your data for verification purposes. This is a one-time process that helps us ensure the security of our platform and your account.',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Verification Process',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        'Please provide a clear image of your CNIC for verification purposes.',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Capture Your CNIC',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GalleryCamera(),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6 * 1.5,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 72.0,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Take a Picture of Your CNIC',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     height: 80.0,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         for (int i = 0; i < 3; i++)
          //           if (i == _currentPage)
          //             PageIndicator(true)
          //           else
          //             PageIndicator(false)
          //       ],
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 20,
            left: 280,
            right: 0,
            child: Container(
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // if (_currentPage != 0)
                  //   TextButton(
                  //     onPressed: () {
                  //       _pageController.previousPage(
                  //         duration: const Duration(milliseconds: 500),
                  //         curve: Curves.easeInOut,
                  //       );
                  //     },
                  //     child: const Text(
                  //       'Back',
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //         color: Colors.blue,
                  //       ),
                  //     ),
                  //   )
                  // else
                  //   Container(),
                  if (_currentPage != 2)
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _goToNextPage,
                      // child: const Text(
                      //   'Next',
                      //   style: TextStyle(
                      //     fontSize: 18.0,
                      //     color: Colors.blue,
                      //   ),
                      // ),
                    )
                  else
                    Container(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: SizedBox(
                height: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? const Color(0xFF1B1B1E)
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
