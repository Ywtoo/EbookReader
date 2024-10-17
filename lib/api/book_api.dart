import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/book.dart';

/// Classe responsável por interagir com a API de livros
class BookApi {
  static const String apiUrl = 'https://pub.dev/packages/vocsy_epub_viewer';

  /// Método estático para buscar a lista de livros
  static Future<List<Book>> fetchBooks() async {
    try {
      // Faz a requisição GET para a URL da API
      final response = await http.get(Uri.parse(apiUrl));

      // Verifica se o status da resposta é 200 (OK)
      if (response.statusCode == 200) {
        // Converte o corpo da resposta em uma lista de objetos Book
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((bookJson) => Book.fromJson(bookJson)).toList();
      } else {
        // Lança uma exceção se o status não for OK
        throw Exception('Falha ao carregar livros da API: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar livros: $e');
      // Repassa a exceção para ser tratada onde a função for chamada
      throw Exception('Erro ao se comunicar com a API de livros');
    }
  }
}