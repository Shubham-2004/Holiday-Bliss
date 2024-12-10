import 'dart:convert';
import 'dart:io'; // For SocketException
import 'package:holiday_bliss/backend/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:holiday_bliss/model/city_model.dart'; // Ensure this import is correct for your City model

class EventPlanAiScreen extends StatefulWidget {
  const EventPlanAiScreen({super.key});

  @override
  State<EventPlanAiScreen> createState() => _EventPlanAiScreenState();
}

class _EventPlanAiScreenState extends State<EventPlanAiScreen> {
  List<City> _cities = [];
  List<City> _filteredCities = [];
  TextEditingController _searchController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _datesController = TextEditingController();
  List<String> _preferences = [
    'Adventure',
    'Relaxation',
    'Family-friendly',
    'Luxury',
    'Budget-friendly',
    'Beach',
    'Mountain',
    'Cultural',
    'Nature',
    'Foodie'
  ];
  List<String> _selectedPreferences = [];
  DateTimeRange? _dateRange;
  bool _isCitySelected = false; // Track if a city is selected

  @override
  void initState() {
    super.initState();
    _loadCities();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _destinationController.dispose();
    _datesController.dispose();
    super.dispose();
  }

  // Load cities from assets
  Future<void> _loadCities() async {
    final String response =
        await rootBundle.loadString('assets/json/cities.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _cities = data.map((e) => City.fromJson(e)).toList();
      _filteredCities = _cities;
    });
  }

  // Search functionality for cities
  void _onSearchChanged() {
    if (_isCitySelected) return; // Skip searching if a city is selected

    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCities = _cities.where((city) {
        return city.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Date picker for selecting travel dates
  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
      initialDateRange: _dateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            hintColor: Colors.teal,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dateRange) {
      setState(() {
        _dateRange = picked;
        _datesController.text =
            "${DateFormat('yyyy-MM-dd').format(picked.start)} - ${DateFormat('yyyy-MM-dd').format(picked.end)}";
      });
    }
  }

  // Generate the content using Gemini API
  Future<void> _generatePlan() async {
    if (_destinationController.text.isEmpty ||
        _dateRange == null ||
        _selectedPreferences.isEmpty) {
      // Show an alert if required fields are missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please complete all fields before proceeding.')),
      );
      return;
    }

    final String inputText = '''
    Plan an event in ${_destinationController.text} from ${DateFormat('yyyy-MM-dd').format(_dateRange!.start)} to ${DateFormat('yyyy-MM-dd').format(_dateRange!.end)}. The preferences are: ${_selectedPreferences.join(', ')}.
    ''';

    final String? generatedContent =
        await ApiService.generateContent(inputText);

    if (generatedContent != null) {
      final String? generatedContent =
          await ApiService.generateContent(inputText);

      if (generatedContent != null) {
        final Map<String, dynamic> response = json.decode(generatedContent);
        final List<dynamic> parts =
            response['candidates'][0]['content']['parts'];
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor:
              Colors.white, // White background for better readability
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0)), // Rounded corners
          ),
          builder: (BuildContext context) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_available, // Event icon
                          color: Colors.blue,
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Event Plan in ${_destinationController.text}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Divider(
                      thickness: 1.5,
                      color: Colors.grey[300]), // Divider for separation
                  SizedBox(height: 12),
                  // Using ListView to handle multiple parts dynamically
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: parts.length,
                      itemBuilder: (context, index) {
                        final String partText = parts[index]['text'];

                        // Remove '*' from the text if present
                        final cleanedText = partText.replaceAll('*', '').trim();

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            '$cleanedText',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.6, // Line height for better readability
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal[300]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: Text(
          'Holiday Planner AI',
          style:
              TextStyle(color: Colors.teal[300], fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(color: Colors.teal, thickness: 2),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'First, where do you want to go?',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    'You get the Custom recs you can Save it and Share it with your friends',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Search for cities (only show if city is not selected)
                  if (!_isCitySelected)
                    TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        hintText: 'Search for a city',
                        hintStyle: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.w400),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  SizedBox(height: 20),
                  // Display filtered cities in a list (only show if city is not selected)
                  if (!_isCitySelected)
                    _filteredCities.isEmpty
                        ? Text(
                            'No cities found',
                            style: TextStyle(color: Colors.white),
                          )
                        : Container(
                            height: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredCities.length,
                              itemBuilder: (context, index) {
                                final city = _filteredCities[index];
                                return ListTile(
                                  title: Text(
                                    city.name,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    '${city.country}',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  onTap: () {
                                    _destinationController.text = city.name;
                                    setState(() {
                                      _isCitySelected = true; // City selected
                                      _filteredCities = []; // Clear suggestions
                                    });
                                    print('Selected City: ${city.name}');
                                  },
                                );
                              },
                            ),
                          ),
                  SizedBox(height: 20),
                  // Destination input field (only show if city is selected)
                  if (_isCitySelected)
                    TextField(
                      controller: _destinationController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter destination',
                        hintStyle: TextStyle(color: Colors.white70),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  // Date range picker
                  TextField(
                    controller: _datesController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      hintText: 'Select travel dates',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today, color: Colors.white),
                        onPressed: _pickDateRange,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Preference chips
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: _preferences.map((preference) {
                      return ChoiceChip(
                        label: Text(
                          preference,
                          style: TextStyle(color: Colors.white),
                        ),
                        selected: _selectedPreferences.contains(preference),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedPreferences.add(preference);
                            } else {
                              _selectedPreferences.remove(preference);
                            }
                          });
                        },
                        selectedColor: Colors.teal,
                        backgroundColor: Colors.grey[800],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: _generatePlan,
                      child: Text("Generate Plan With AI")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
