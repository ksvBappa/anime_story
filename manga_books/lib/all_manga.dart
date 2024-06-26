import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'book_valumes.dart';
import 'manga_screen.dart'; // Import your manga screen here

class AllMangaList extends StatefulWidget {
  @override
  State<AllMangaList> createState() => _AllMangaListState();
}

class _AllMangaListState extends State<AllMangaList> {
  List<dynamic> mangaList = [];
  bool isLoading = true;
  final String accessToken = 'your_access_token'; // Replace with your actual access token
  final baseurl = 'https://newsonbox.com/anime_story/';

  @override
  void initState() {
    super.initState();
    fetchMangaList();
  }

  Future<void> fetchMangaList() async {
    final url = Uri.parse('https://newsonbox.com/anime_story/api/booklist_api.php'); // Replace with your API URL
    // final headers = {
    //   'Content-Type': 'application/x-www-form-urlencoded',
    //   'Authorization': 'Bearer $accessToken', // Replace with your actual token
    // };
    final body = {
      'token': 'ksv_27111203' // Replace with the actual PIN you want to send
    };

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      setState(() {
        mangaList = json.decode(response.body);
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load manga');
    }
  }

  @override
  Widget build(BuildContext context) {
    var xaxis = MediaQuery.of(context).size.width;
    var yaxis = MediaQuery.of(context).size.height;
    var gridH = yaxis / 4.5;
    var gridW = xaxis / 3.5;

    return Scaffold(
      appBar: AppBar(
        title: Text('All Comic Lists'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                primary: false,
                childAspectRatio: (gridW / gridH),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: false,
                children: <Widget>[
                  for (var manga in mangaList) ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BookVolumes(bookId:manga['book_id'],wallpaper:baseurl+manga['thumbnail'])),
                        );
                        print('Container tapped!');
                      },
                      child: Container(
                        height: yaxis / 4,
                        width: xaxis / 3.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(

                            image: NetworkImage(baseurl+manga['thumbnail']), // Adjust according to your API response
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CategoryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
