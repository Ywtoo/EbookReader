import 'package:flutter/material.dart'; 
import '../api/book_api.dart'; 
import '../models/book.dart'; 
import '../widgets/book_cover.dart'; 
import 'book_details_screen.dart'; 

class BookshelfScreen extends StatefulWidget {
  const BookshelfScreen({super.key});

  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  late Future<List<Book>> _booksFuture; // Futuro para a lista de livros

  @override
  void initState() {
    super.initState();
    _booksFuture = BookApi.fetchBooks(); // Inicia a busca pelos livros
  }

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
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(book: book), // Navega para os detalhes do livro
                      ),
                    );
                  },
                  child: BookCover(book: book), // Exibe a capa do livro
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar livros')); // Mensagem de erro
          }
          return const Center(child: CircularProgressIndicator()); // Indicador de carregamento
        },
      ),
    );
  }
}