// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'castedvote.dart';

class VoteCastScreen extends StatelessWidget {
  final dynamic candidate;
  final String image;
  final String cnic;
  final String hash;

  const VoteCastScreen({
    Key? key,
    required this.candidate,
    required this.cnic,
    required this.hash,
    required this.image,
  }) : super(key: key);

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
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        "You are voting for...",
                      ),
                      Text(
                        candidate,
                        style: const TextStyle(
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          image,
                          width: double.infinity,
                          height: 190,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 18.0,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        candidate,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'CNIC',
                        style: TextStyle(
                          fontSize: 18.0,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        cnic,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 40),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              //bool hasVoted = await vote_check(hash);

                              if (await vote_check(hash) == false) {
                                print("Already Voted");
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Already Voted'),
                                      content:
                                          const Text('You have already voted.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            //exit from the appliction and go to the home screen
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            
                                            
                                            // Navigator.pop(
                                            //     context); // Dismiss the dialog
                                          },
                                          style: TextButton.styleFrom(
                                            // foregroundColor:
                                            //     const Color(0xFFED8B30),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 224, 41, 41),
                                            minimumSize:
                                                const Size(double.infinity, 40),
                                            //primary: const Color(0xFFED8B30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
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
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    const Text(
                                      'Your vote is being casted. Please wait...',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                                await sendToBlockchain(hash, cnic);

                                Navigator.pop(
                                    context); // Dismiss the loading dialog

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CastedVote(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              primary: const Color(0xFFED8B30),
                              onPrimary: const Color(0xFF000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Vote Now',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              foregroundColor: const Color(0xFFFFFFFF),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                            child: const Text(
                              'Change Candidate',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
          ],
        ),
      ),
    );
  }

  Future<void> sendToBlockchain(String voter, String votedTo) async {
    // Voter has not voted yet, make API call to cast vote
    String apiUrl =
        'http://35.184.173.190:30007/castVote?voter=$voter&voted=$votedTo';
    // Map<String, dynamic> requestBody = {
    //   'voter': hash,
    //   'voted': cnic,
    // };
    debugPrint('Sending to blockchain: $voter, $votedTo');

    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Vote successfully casted
      print('Vote casted successfully!');
    } else {
      // Error occurred while casting vote
      print('Error casting vote. Status code: ${response.statusCode}');
    }
  }

  Future<bool> vote_check(String voter) async {
    String endpointUrl = "http://35.184.173.190:30007/getVote";
    Map<String, String> queryParams = {
      "voter": voter,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    endpointUrl += '?$queryString';

    print("sending request to vote check: $endpointUrl");
    var response = await http.get(Uri.parse(endpointUrl));
    print("response: ${response.body}");
    var data = (response.body);
    print("data: $data");

    if (data == "Error executing command") {
      return true;
    } else {
      return false;
    }
  }
}
