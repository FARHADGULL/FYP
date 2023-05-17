import 'package:evm_app/screenNavigation.dart';
import 'package:flutter/material.dart';
import 'candidates.dart';

class LandingPage extends StatelessWidget {
  //final String name;
  final String cnic;
  final Map<String, dynamic> matchResult;

  const LandingPage({
    Key? key,
    required this.cnic,
    required this.matchResult,
  }) : super(key: key);

  // Rest of the code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(
                top: 48.0,
                bottom: 10.0,
                right: 10.0,
                left: 10.0,
              ),
              decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: const BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Voting Starts in",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "10 days",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 50.0,
                      bottom: 250.0,
                      right: 5.0,
                      left: 10.0,
                    ),
                    padding: const EdgeInsets.only(
                      left: 5.0,
                      right: 5.0,
                      top: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Get Verified",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScreenContainer(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 50.0,
                      bottom: 250.0,
                      right: 10.0,
                    ),
                    // ignore: prefer_const_constructors
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: 5.0,
                      right: 5.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "Cast     Vote Now",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CandidateScreen(
                                  cnic: cnic,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: matchResult['compare'] == true
                    ? Colors.green[300]
                    : Colors.red[300],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    matchResult['compare'] == true
                        ? 'Verification Successful'
                        : 'Verification Failed',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    matchResult['compare'] == true
                        ? 'You are now verified and eligible to vote.'
                        : 'Please verify your CNIC to cast your vote.',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
