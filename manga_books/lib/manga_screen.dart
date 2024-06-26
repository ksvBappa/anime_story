import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SingleMangaScreen extends StatefulWidget {
  final String book_link;
  const SingleMangaScreen({super.key,required this.book_link});
  @override
  State<SingleMangaScreen> createState() => _SingleMangaScreenState();
}

class _SingleMangaScreenState extends State<SingleMangaScreen> {
  int pageNumber = 1; // Initial page number
  final baseurl = 'https://newsonbox.com/anime_story/';



  @override
  Widget build(BuildContext context) {
    print(baseurl+widget.book_link);
    return Scaffold(
      appBar: AppBar(
        title: Text('Read From Here'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [


            Expanded(child: SfPdfViewer.network(baseurl+widget.book_link)),
            // Text('Page $pageNumber'), // Display current page number
          ],
        ),
      ),
    );
  }
}
