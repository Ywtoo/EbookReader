import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/book_cover.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Book> _favoriteBooks = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteBooks();
  }
//tentativa de favoritos
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavoriteBooks();
  }

  Future<void> _loadFavoriteBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteBooksJson = prefs.getStringList('favoriteBooks') ?? [];

    setState(() {
      _favoriteBooks = favoriteBooksJson
          .map((bookJson) => Book.fromJson(json.decode(bookJson) as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> _toggleFavorite(Book book) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      book.isFavorite = !book.isFavorite;
      if (book.isFavorite) {
        _favoriteBooks.add(book);
      } else {
        _favoriteBooks.remove(book);
      }
    });

    final favoriteBooksJson = _favoriteBooks
        .map((book) => json.encode(book.toJson()))
        .toList();
    await prefs.setStringList('favoriteBooks', favoriteBooksJson);
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: _favoriteBooks.isEmpty
          ? const Center(
              child: Text('Você não tem livros favoritos ainda.'),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: _favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = _favoriteBooks[index];
                return GestureDetector(
                  onTap: () {
                    // Navegar para a tela de detalhes do livro
                  },
                  child: Stack(
                    children: [
                      BookCover(book: book),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            book.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: book.isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _toggleFavorite(book).then((_) {
                                _loadFavoriteBooks();
                              });
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}