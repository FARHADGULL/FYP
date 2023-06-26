import 'package:Intekhab/view/votecast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CandidateScreen extends StatefulWidget {
  final String cnic;
  final String hash;

  const CandidateScreen({Key? key, required this.cnic, required this.hash})
      : super(key: key);

  @override
  _CandidateScreenState createState() => _CandidateScreenState();
}

class _CandidateScreenState extends State<CandidateScreen> {
  final apiUrl =
      'https://cast-candidate-v1-aidrghpmva-uc.a.run.app/fetch_candidates';

  Future<List<dynamic>> fetchCandidates() async {
    print("sending request to $apiUrl");
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('fetchCandidates(): ${response.statusCode}');
      final decodedData = jsonDecode(response.body) as List<dynamic>;
      print('decodedData: $decodedData');
      return decodedData;
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch candidates');
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
                child: FutureBuilder<List<dynamic>>(
                  future: fetchCandidates(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Filter the data based on remainder of the 1st digit of the CNIC with 5
                      final filteredData = snapshot.data!.where((candidate) {
                        return int.parse(widget.cnic[0]) % 5 ==
                            int.parse(candidate['constituency']) % 5;
                      }).toList();
                      print('filteredData: $filteredData');

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Municipality\nCandidates',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(1),
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                final candidate = filteredData[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height:
                                            210, // Set the desired height for the image
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            candidate['image_url'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                candidate['name'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                candidate['CNIC_Number'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 110),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          VoteCastScreen(
                                                        candidate:
                                                            candidate['name'],
                                                        image: candidate[
                                                            'image_url'],
                                                        cnic: candidate[
                                                            'CNIC_Number'],
                                                        hash: widget.hash,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: const Size(
                                                      double.infinity, 35),
                                                  primary:
                                                      const Color(0xFF0A4F27),
                                                  onPrimary:
                                                      const Color(0xFF000000),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Vote',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
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
}
