import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holiday_bliss/presentation/screens/screens/live_location_screen.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;

  String? city;
  String? budget;
  String? tripPurpose;
  String? priorities;
  int? guests;

  // Function to fetch hotel details
  Future<void> fetchHotelDetails(String city, String budget, String tripPurpose,
      String priorities, int guests) async {
    setState(() {
      isLoading = true;
    });

    try {
      final String apiEndpoint =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';
      const String apiKey = 'AIzaSyCdBrP8GOaGjQgdX1RYOJnHo4xm8D61lmQ';

      final requestBody = json.encode({
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Provide hotel details in $city for a $tripPurpose trip, with a $budget budget, for $guests guests. Preferences: $priorities."
              }
            ]
          }
        ]
      });

      final response = await http.post(
        Uri.parse('$apiEndpoint?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extracting parts from the response
        final List<dynamic> parts =
            data['candidates'][0]['content']['parts'] ?? [];

        setState(() {
          searchResults = parts;
        });

        // Printing results in the specified format
        for (var part in parts) {
          print("Hotel Details: ${part['text']}");
        }
      } else {
        print(
            'API call failed: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during API request: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showPreferencesForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(labelText: 'City'),
                onChanged: (value) => city = value,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (city != null && city!.isNotEmpty) {
                    setState(() {
                      city = _searchController.text;
                    });
                    Navigator.pop(context);
                    _showHotelDetailsForm(context); // Show preferences form
                  }
                },
                child: const Text('Enter Preferences'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHotelDetailsForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 700,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Budget'),
                  onChanged: (value) => budget = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Trip Purpose'),
                  onChanged: (value) => tripPurpose = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Priorities'),
                  onChanged: (value) => priorities = value,
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Number of Guests'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => guests = int.tryParse(value),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (city != null &&
                        budget != null &&
                        tripPurpose != null &&
                        priorities != null &&
                        guests != null) {
                      fetchHotelDetails(
                        city!,
                        budget!,
                        tripPurpose!,
                        priorities!,
                        guests!,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Search Hotels'),
                ),
                SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(
                          height: 100,
                          width: double.infinity,
                          image: NetworkImage(
                              'https://www.ourescapeclause.com/wp-content/uploads/2016/05/shutterstock_1075238006-scaled.jpg')),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Search Hotels',
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LiveLocationPage()));
                },
                icon: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 26,
                )),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter City',
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'Search for hotels in your city...',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey,
              ),
              onChanged: (value) {
                setState(() {
                  city = value;
                });
              },
              onSubmitted: (value) {
                if (city != null && city!.isNotEmpty) {
                  _showPreferencesForm(context);
                }
              },
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final result = searchResults[index]['text'];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hotel Details:",
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                result ?? 'No details available',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
