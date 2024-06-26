import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'manga_screen.dart';

class BookVolumes extends StatefulWidget {
  final String bookId;
  final String wallpaper;

  const BookVolumes({Key? key, required this.bookId,required this.wallpaper}) : super(key: key);

  @override
  State<BookVolumes> createState() => _BookVolumesState();
}

class _BookVolumesState extends State<BookVolumes> {
  List<dynamic> bookVolumes = [];
  bool isLoading = true;
  final baseurl = 'https://newsonbox.com/anime_story/';

  @override
  void initState() {
    super.initState();
    fetchBookVolumes();
  }

  Future<void> fetchBookVolumes() async {
    final url = Uri.parse('${baseurl}api/booklist_vol_api.php');
    final body = {
      'token': 'ksv_27111203',
      'book_id': widget.bookId,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(jsonDecode(response.body));
        setState(() {
          bookVolumes = data; // Adjust based on your API response structure
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Network error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var xaxis = MediaQuery.of(context).size.width;
    var yaxis = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Volumes'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(widget.wallpaper),// Add your desired background image
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.black.withOpacity(0.5),
                    child: Text(
                      'Description', // Add your description here
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15,),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: isLoading
                    ? CircularProgressIndicator()
                    : ListView.builder(
                  itemCount: bookVolumes.length,
                  itemBuilder: (context, index) {
                    final bookVolume = bookVolumes[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                    baseurl + bookVolume['thumbnail']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                bookVolume['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                bookVolume['description'],
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.favorite_border),
                                onPressed: () {
                                  // Add your like button functionality here
                                  print('Like button pressed!');
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingleMangaScreen(
                                        book_link: bookVolume['pdf_file']),
                                  ),
                                );
                                print('Container tapped!');
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
