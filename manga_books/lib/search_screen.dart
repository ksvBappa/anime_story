import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchController _searchController;
  late Future<List<String>> _searchResults;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
    _searchResults = Future.value([]);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<List<String>> fetchSearchResults(String query) async {
    final headers = {
      'token': 'ksv_27111203',
    };
    final response = await http.get(
      Uri.parse('https://newsonbox.com/anime_story/api/search-book-api.php?title=$query'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item.toString()).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }

  void _updateSearchResults(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchResults = fetchSearchResults(query);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (String query) {
                  _updateSearchResults(query);
                  controller.openView();
                },
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                trailing: <Widget>[
                  Tooltip(
                    message: 'Search',
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ),
                ],
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              return [
                FutureBuilder<List<String>>(
                  future: _searchResults,
                  builder: (context, snapshot) {
                    List<Widget> children;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      children = [ListTile(title: Text('Loading...'))];
                    } else if (snapshot.hasError) {
                      children = [ListTile(title: Text('Error: ${snapshot.error}'))];
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      children = [ListTile(title: Text('No results found'))];
                    } else {
                      children = snapshot.data!.map((result) {
                        return ListTile(
                          title: Text(result),
                          onTap: () {
                            controller.closeView(result);
                          },
                        );
                      }).toList();
                    }
                    return Column(children: children);
                  },
                )
              ];
            },
          ),
        ),
      ),
    );
  }
}
