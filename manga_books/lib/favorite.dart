import 'package:flutter/material.dart';
import 'manga_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    var xaxis = MediaQuery.of(context).size.width;
    var yaxis = MediaQuery.of(context).size.height;
    var gridH = yaxis / 4.5;
    var gridW = xaxis / 3.5;
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite List'),
      ),
      body: GridView.count(
        primary: false,
        childAspectRatio: (gridW / gridH),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        children: List.generate(18, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleMangaScreen(book_link: '2'),
                ),
              );
            },
            child: Container(
              height: yaxis / 4,
              width: xaxis / 3.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('assets/images/anime_${index >= 9 ? index - 8 : index + 1}.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
