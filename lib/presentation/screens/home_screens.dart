import 'package:flutter/material.dart';
import 'package:holiday_bliss/presentation/screens/screens/account_screen.dart'; // Assuming you have a separate content widget
import 'package:holiday_bliss/presentation/screens/screens/home_screen_widget.dart';
import 'package:holiday_bliss/presentation/screens/screens/plan_screen.dart';
import 'package:holiday_bliss/presentation/screens/screens/review_screen.dart';
import 'package:holiday_bliss/presentation/screens/screens/search_screen.dart';
import 'package:holiday_bliss/widgets/buttons/homescreen_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;

  // List of pages to navigate to
  final List<Widget> _pages = [
    const HomeScreenContent(), // Separate widget for home content
    const SearchScreen(),
    const PlanScreen(),
    const ReviewScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPageIndex], // Directly use the selected page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        currentIndex: _currentPageIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Review',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
