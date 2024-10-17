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
  List<Book> _favoriteBooks = []; // Lista para armazenar livros favoritos

  @override
  void initState() {
    super.initState();
    _loadFavoriteBooks(); // Carrega os livros favoritos ao iniciar o estado
  }

  Future<void> _loadFavoriteBooks() async {
    final prefs = await SharedPreferences.getInstance(); // Obtém a instância de SharedPreferences
    final favoriteBooksJson = prefs.getStringList('favoriteBooks') ?? []; // Recupera a lista de livros favoritos

    setState(() {
      // Atualiza a lista de livros favoritos
      _favoriteBooks = favoriteBooksJson
          .map((bookJson) => Book.fromJson(json.decode(bookJson))) // Converte o JSON de volta para objetos Book
          .toList();
    });
  }

  Future<void> _toggleFavorite(Book book) async {
    final prefs = await SharedPreferences.getInstance(); // Obtém a instância de SharedPreferences

    setState(() {
      // Alterna o status de favorito do livro
      book.isFavorite = !book.isFavorite;
      if (book.isFavorite) {
        _favoriteBooks.add(book); // Adiciona o livro à lista de favoritos
      } else {
        _favoriteBooks.remove(book); // Remove o livro da lista de favoritos
      }
    });

    final favoriteBooksJson = _favoriteBooks
        .map((book) => json.encode(book.toJson())) // Converte os livros favoritos de volta para JSON
        .toList();
    await prefs.setStringList('favoriteBooks', favoriteBooksJson); // Armazena a lista atualizada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'), // Título da tela
      ),
      body: _favoriteBooks.isEmpty
          ? const Center(
              child: Text('Você não tem livros favoritos ainda.'), // Mensagem se não houver favoritos
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Número de colunas no grid
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: _favoriteBooks.length, // Número total de livros
              itemBuilder: (context, index) {
                final book = _favoriteBooks[index]; // Obtém o livro na posição atual
                return GestureDetector(
                  onTap: () {
                    // Navegar para a tela de detalhes do livro (funcionalidade a ser implementada)
                  },
                  child: Stack(
                    children: [
                      BookCover(book: book), // Exibe a capa do livro
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            book.isFavorite
                                ? Icons.favorite // Ícone de favorito
                                : Icons.favorite_border, // Ícone de não favorito
                            color: book.isFavorite ? Colors.red : Colors.grey, // Altera a cor do ícone
                          ),
                          onPressed: () {
                            _toggleFavorite(book); // Alterna o status de favorito
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