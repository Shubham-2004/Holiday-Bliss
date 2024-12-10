import 'dart:async';
import 'package:flutter/material.dart';
import 'package:holiday_bliss/widgets/city_card.dart';

class CardSlider extends StatefulWidget {
  @override
  _CardSliderState createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  final PageController _pageController =
      PageController(viewportFraction: 0.9); // Adjusted to show adjacent cards
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> events = [
    {
      'location': 'London',
      'imageUrl':
          'https://cdn.britannica.com/35/156335-050-62245FCA/Tower-Bridge-River-Thames-London.jpg',
    },
    {
      'location': 'Paris',
      'imageUrl':
          'https://th.bing.com/th/id/OIP.E3PPsxjqt3N4DOy51yERUgHaE7?rs=1&pid=ImgDetMain',
    },
    {
      'location': 'Tokyo',
      'imageUrl':
          'https://th.bing.com/th/id/OIP.llpRwKpTfsB52Yg4CNaXogHaE8?rs=1&pid=ImgDetMain',
    },
    {
      'location': 'Singapore',
      'imageUrl':
          'https://mediaim.expedia.com/localexpert/1378878/a052e968-fd05-40be-87f8-3b9c966c6da2.jpg',
    },
    {
      'location': 'Mumbai',
      'imageUrl':
          'https://1.bp.blogspot.com/-uqv7sYU74Ho/Xgtlb2rRVEI/AAAAAAAADBs/Dcwg7IYfX6MFp84yHuXd9Vzy7xmvquT-wCLcBGAsYHQ/s1600/u.6.jpg',
    },
  ];

  late List<Map<String, String>> duplicatedEvents;

  @override
  void initState() {
    super.initState();
    duplicatedEvents = List.from(events)..addAll(events);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_currentPage < duplicatedEvents.length - 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 800),
          curve: Curves.ease,
        );
      } else {
        _currentPage = events.length;
        _pageController.jumpToPage(_currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: 230,
            child: PageView.builder(
              controller: _pageController,
              itemCount: duplicatedEvents.length,
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
                if (_currentPage == duplicatedEvents.length - 1) {
                  _currentPage = events.length - 1;
                  _pageController.jumpToPage(_currentPage);
                }
              },
              itemBuilder: (context, index) {
                final event = duplicatedEvents[index];
                return EventCard(
                  location: event['location']!,
                  imageUrl:
                      event['imageUrl']!, // Pass the image URL to the card
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(events.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage % events.length == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage % events.length == index
                        ? Colors.teal
                        : Colors.grey[300],
                    borderRadius: _currentPage % events.length == index
                        ? BorderRadius.circular(12)
                        : BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
