import 'package:shared_preferences/shared_preferences.dart';

class Book {
  final String title;
  final String author;
  final String coverUrl;
  final String downloadUrl;
  bool isFavorite;

  //Inicializa todas as propriedades obrigatorias(favorite fica como opcional)
  Book({
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.downloadUrl,
    this.isFavorite = false,
  });

  factory Book.fromJson(Map<String, dynamic>json) {
    return Book(
      title: json['title'],
      author: json['author'],
      coverUrl: json['cover_url'],
      downloadUrl: json['download_url'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }


  //Reverte para json de novo
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'cover_url': coverUrl,
      'download_url': downloadUrl,
      'isFavorite': isFavorite,
    };
  }
  //Tentativa de fazer os favoritos
  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTitle = Uri.encodeComponent(title);
    isFavorite = !isFavorite;
    await prefs.setBool('favorite_$encodedTitle', isFavorite);
  }

  // Método para carregar o estado de favorito
  Future<void> loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTitle = Uri.encodeComponent(title);
    isFavorite = prefs.getBool('favorite_$encodedTitle') ?? false;
  }
}