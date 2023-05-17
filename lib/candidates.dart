import 'package:evm_app/votecast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CandidateScreen extends StatefulWidget {
  final String cnic;

  const CandidateScreen({Key? key, required this.cnic}) : super(key: key);

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
      appBar: AppBar(
        title: const Text(
          'Your Candidates',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
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
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final candidate = filteredData[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: ListTile(
                            leading: Image.network(candidate['image_url']),
                            title: Text(candidate['name']),
                            subtitle: Text(candidate['CNIC_Number']),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VoteCastScreen(
                                    candidate: candidate,
                                    cnic: widget.cnic,
                                  ),
                                ),
                              );
                            },
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
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
