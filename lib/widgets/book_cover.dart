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
          height: 130, // Altura da imagem
          width: 100, // Largura da imagem
          fit: BoxFit.cover, // Ajusta a imagem para cobrir a área disponível
        ),
        const SizedBox(height: 5), // Espaçamento entre a imagem e o título
        Text(
          book.title.length > 30 // Verifica se o título tem mais de 20 caracteres
              ? '${book.title.substring(0, 30)}...' // Se sim, exibe apenas os primeiros 20 caracteres e adiciona "..."
              : book.title, // Se não, exibe o título completo
          maxLines: 2, // Limita a duas linhas
          overflow: TextOverflow.ellipsis, // Adiciona reticências se o texto for longo
          textAlign: TextAlign.center, // Centraliza o texto
          style: const TextStyle(fontSize: 12.0), // Adicionado estilo ao título
        ),
        Text(
          book.author, // Autor do livro
          style: const TextStyle(fontSize: 10), // Estilo do texto para o autor
        ),
      ],
    );
  }
}