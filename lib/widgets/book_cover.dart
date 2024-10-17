import 'package:flutter/material.dart';
import '../models/book.dart';

class BookCover extends StatelessWidget {
  final Book book; // Recebe um objeto Book

  const BookCover({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Exibe a imagem da capa do livro
        Image.network(
          book.coverUrl,
          height: 100, // Altura da imagem
          width: 100, // Largura da imagem
          fit: BoxFit.cover, // Ajusta a imagem para cobrir a área disponível
        ),
        const SizedBox(height: 5), // Espaçamento entre a imagem e o título
        Text(
          book.title, // Título do livro
          maxLines: 2, // Limita a duas linhas
          overflow: TextOverflow.ellipsis, // Adiciona reticências se o texto for longo
          textAlign: TextAlign.center, // Centraliza o texto
        ),
        Text(
          book.author, // Autor do livro
          style: const TextStyle(fontSize: 12), // Estilo do texto para o autor
        ),
      ],
    );
  }
}