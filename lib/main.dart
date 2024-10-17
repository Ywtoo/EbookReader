import 'package:flutter/material.dart';
import 'screens/bookshelf_screen.dart';
import 'screens/favorites_screen.dart';

void main() {
  runApp(const MyApp()); // Inicia o aplicativo
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leitor de eBooks', // Título do aplicativo
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define a cor primária do tema
      ),
      home: DefaultTabController(
        length: 2, // Número de abas na TabBar
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Meu Aplicativo de Livros'), // Título da AppBar
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Livros'), // Primeira aba
                Tab(text: 'Favoritos'), // Segunda aba
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              BookshelfScreen(), // Tela de livros
              FavoritesScreen(), // Tela de favoritos
            ],
          ),
        ),
      ),
    );
  }
}