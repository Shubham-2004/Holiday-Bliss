import 'package:flutter/material.dart';
import 'package:holiday_bliss/presentation/screens/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://axtkzfjvtkwmivqhxzfn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF4dGt6Zmp2dGt3bWl2cWh4emZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM4NDM5NzQsImV4cCI6MjA0OTQxOTk3NH0.dpYs2O7Z4dW5UM_ndMDOePOguMcSv73BqYrbIbxjfAo',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        highlightColor: Colors.teal,
        primarySwatch: Colors.teal, // Set the primary color to teal
        hintColor: Colors.teal, // Set the accent color to teal
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.teal, // Buttons will have teal color
        ),
        scaffoldBackgroundColor: Colors.black87, // Set background color
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black, // AppBar will have black background
          titleTextStyle: TextStyle(
              color: Colors.white, // Title text color will be white
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.teal, // TextButton link color will be teal
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.teal), // Label text will be teal
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.teal), // Border color for inputs
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}
