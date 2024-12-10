import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HotelWebsitesSlider extends StatelessWidget {
  final List<Map<String, String>> hotelWebsites = [
    {
      'name': 'Goibibo',
      'imageUrl':
          'https://miro.medium.com/v2/resize:fit:2400/2*5HSa5sD7PbzdQsazOcJFVg.png',
      'url': 'https://www.goibibo.com/',
    },
    {
      'name': 'MakeMyTrip',
      'imageUrl':
          'https://w7.pngwing.com/pngs/598/909/png-transparent-makemytrip-flight-travel-hotel-india-travel.png',
      'url': 'https://www.makemytrip.com/',
    },
    {
      'name': 'Trivago',
      'imageUrl':
          'https://th.bing.com/th/id/OIP.7MyEk564Z1W5Vp4Pni526AHaJg?rs=1&pid=ImgDetMain',
      'url': 'https://www.trivago.com/',
    },
    {
      'name': 'Booking.com',
      'imageUrl':
          'https://th.bing.com/th/id/OIP._G_OhX9PrcMrXyAFxn7JHwAAAA?rs=1&pid=ImgDetMain',
      'url': 'https://www.booking.com/',
    },
    {
      'name': 'Expedia',
      'imageUrl':
          'https://th.bing.com/th/id/OIP.v8Azu8s0oLV7xEUkwqfk9wHaG0?rs=1&pid=ImgDetMain',
      'url': 'https://www.expedia.com/',
    },
  ];

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      )) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: hotelWebsites.map((website) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => _launchURL(website['url']!),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(website['imageUrl']!),
                      radius: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      website['name']!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
