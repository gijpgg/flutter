import 'package:flutter/material.dart';
import 'dart:convert';
import 'api.dart';
import 'detail.dart';

class MoviesListView extends StatefulWidget {
  const MoviesListView({Key? key}) : super(key: key);

  @override
  State<MoviesListView> createState() => _MoviesListViewState();
}

class _MoviesListViewState extends State<MoviesListView> {
  List<Movie> movies = [];
  late TextEditingController _searchController;
  String search = "star%20trek";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: search);
    _fetchMovies(search);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchMovies(String search) {
    API.getMovie(search).then((response) {
      setState(() {
        Iterable lista = json.decode(response.body);
        movies = lista.map((model) => Movie.fromJson(model)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Filmes"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Digite o nome do filme",
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      search = _searchController.text.trim();
                      _fetchMovies(search);
                    });
                  },
                  child: const Text("Procurar"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      movies[index].image,
                    ),
                  ),
                  title: Text(
                    movies[index].name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(movies[index].link),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(movies[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
