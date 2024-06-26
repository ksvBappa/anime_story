import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // Ensure this is the correct path to your login screen

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/anime_8.jpeg',
      'title': 'Welcome to Anime Story',
      'description': 'The AI Anime studio in your phone.'
    },
    {
      'image': 'assets/images/anime_2.jpeg',
      'title': 'Explore',
      'description': 'Find your favorites and explore new series.'
    },
    {
      'image': 'assets/images/anime_4.jpeg',
      'title': 'Get Started',
      'description': 'Start your journey now.'
    },
  ];
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _finishOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(), // Navigate to login screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return _buildPageContent(
                image: _pages[index]['image']!,
                title: _pages[index]['title']!,
                description: _pages[index]['description']!,
                showButton: index == _pages.length - 1,
              );
            },
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _buildIndicator(),
                SizedBox(height: 20),
                if (_currentIndex == _pages.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      _finishOnboarding(context);
                    },
                    child: Text('Let\'s get Started'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent({
    required String image,
    required String title,
    required String description,
    required bool showButton,
  }) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              title,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            // Spacer(),
            SizedBox(height: 60),
            if (showButton)
              SizedBox(height: 60), // Leave space for the button at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentIndex == index ? 12.0 : 8.0,
          height: _currentIndex == index ? 12.0 : 8.0,
          decoration: BoxDecoration(
            color: _currentIndex == index ? Colors.white : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
