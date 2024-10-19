import 'package:flutter/material.dart';
import '../api/book_api.dart';
import '../models/book.dart';
import '../widgets/book_cover.dart';
import 'book_details_screen.dart';
import '../widgets/favorite_ribbon.dart';

class BookshelfScreen extends StatefulWidget {
  const BookshelfScreen({super.key});

  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  late Future<List<Book>> _booksFuture;

   @override
  void initState() {
    super.initState();
    _booksFuture = BookApi.fetchBooks().then((books) {
      // Carrega o estado de favorito de cada livro ao buscar a lista
      for (var book in books) {
        book.loadFavoriteStatus();
      }
      return books;
    });
  }
  //itens ta tela principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estante de Livros'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 100,
              ),
               padding: const EdgeInsets.all(10),
              itemCount: snapshot.data!.length, // Número normal de livros
              itemBuilder: (context, index) {
                final book = snapshot.data![index]; // Acesse o livro diretamente
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(book: book),
                      ),
                    );
                  },
                  child: Stack( // Stack para sobrepor a fita e a capa
                    children: [
                      BookCover(book: book),
                      Positioned( // Posiciona a fita
                        top: 10.0,
                        right: 10.0,
                        child: FavoriteRibbon(
                          isFavorite: book.isFavorite,
                          onTap: () {
                            setState(() {
                              book.toggleFavorite();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar livros'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}