import 'package:flutter/material.dart';
import 'package:manga_books/profile.dart';
import 'package:manga_books/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'all_manga.dart';
import 'bottom_nav.dart';
import 'favorite.dart';
import 'onboarding.dart';
import 'home.dart';
import 'theme_changer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            home: FutureBuilder<bool>(
              future: _checkIfSeenOnboarding(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.data == true) {
                    return FutureBuilder<bool>(
                      future: _checkIfLoggedIn(),
                      builder: (context, loginSnapshot) {
                        if (loginSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (loginSnapshot.data == true) {
                            return MainScreen();
                          } else {
                            return LoginScreen();
                          }
                        }
                      },
                    );
                  } else {
                    return OnboardingScreen();
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }

  Future<bool> _checkIfSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seenOnboarding') ?? false;
  }

  Future<bool> _checkIfLoggedIn() async {
    // Replace with your actual authentication check
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2;

  final List<Widget> _pages = [
    AllMangaList(),
    SearchScreen(),
    HomePage(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
