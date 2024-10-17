class Book{
  //Pega as informaçoes dos livros
  final String title;
  final String author;
  final String coverUrl;
  final String downloadUrl;
  bool isFavorite; //indica se é favorito

  //Inicializa todas as propriedades obrigatorias(favorite fica como opcional)
  Book({
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.downloadUrl,
    this.isFavorite = false,
  });

  //Cria um objeto a partir de um JSON
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
}