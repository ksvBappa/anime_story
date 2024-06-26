import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'theme_changer.dart';
import 'manga_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;
  List<String> imgList = [];
  List<String> gridImageList = [];
  final baseUrl = 'https://newsonbox.com/anime_story/';

  @override
  void initState() {
    super.initState();
    fetchCarouselImages();
    fetchGridImages();
  }

  Future<void> fetchCarouselImages() async {
    final url = Uri.parse(
        'https://newsonbox.com/anime_story/api/latest-carousal-api.php');
    final body = {
      'token': 'ksv_27111203',
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            imgList = List<String>.from(data.map((item) {
              return item['wallpaper'] ?? ''; // Ensure 'wallpaper' exists
            }).where((item) => item.isNotEmpty)); // Filter out empty strings
          });
        } else {
          print('Unexpected data format');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
    }
  }

  Future<void> fetchGridImages() async {
    final url =
    Uri.parse('https://newsonbox.com/anime_story/api/booklist_api.php');
    final body = {
      'token': 'ksv_27111203',
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            gridImageList = List<String>.from(data.map((item) {
              return item['thumbnail'] ?? ''; // Ensure 'thumbnail' exists
            }).where((item) => item.isNotEmpty)); // Filter out empty strings
          });
        } else {
          print('Unexpected data format');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
    }
  }

  List<Widget> generateImageTiles() {
    return imgList
        .map(
          (element) => ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.network(
          baseUrl + element,
          fit: BoxFit.cover,
          width: 1000,
        ),
      ),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var yaxis = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Read Anything',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(
              Provider.of<ThemeProvider>(context).currentTheme == ThemeData.light()
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              imgList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                child: CarouselSlider(
                  items: generateImageTiles(),
                  options: CarouselOptions(
                    height: yaxis / 3.5,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    autoPlay: true, // Enable auto-slide
                    autoPlayInterval: Duration(seconds: 3), // Interval between slides
                    autoPlayCurve: Curves.fastOutSlowIn,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Recent',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              gridImageList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                height: MediaQuery.of(context).size.width / 2 - 10,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: gridImageList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width / 3 - 10,
                      margin: EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleMangaScreen(
                                book_link: gridImageList[index], // Pass the correct link
                              ),
                            ),
                          );
                          print('Grid item tapped!');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: NetworkImage(baseUrl + gridImageList[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Trending',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              gridImageList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                height: MediaQuery.of(context).size.width / 2 - 10,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: gridImageList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width / 3 - 10,
                      margin: EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleMangaScreen(
                                book_link: gridImageList[index], // Pass the correct link
                              ),
                            ),
                          );
                          print('Grid item tapped!');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: NetworkImage(baseUrl + gridImageList[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
