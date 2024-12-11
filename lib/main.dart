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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
