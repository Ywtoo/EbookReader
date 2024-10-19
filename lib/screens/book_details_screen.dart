import 'package:flutter/material.dart';
import '../models/book.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'dart:io';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  // Construtor da classe BookDetailsScreen que requer um livro
  const BookDetailsScreen({super.key, required this.book});

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState(); // Cria o estado para a tela de detalhes do livro
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  Future<void> _downloadAndOpenBook() async {
    // 1. Solicitar Permissões
    if (Platform.isAndroid) {
      if (!await Permission.storage.isGranted) {
        if (await Permission.storage.request().isGranted) {
        } else {
          // Permissão negada, exiba uma mensagem para o usuário
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permissão de armazenamento negada!'),
            ),
          );
          return;
        }
      }
    }

    setState(() {
      _isDownloading = true;
    });

    try {
      // 2. Baixar o ePub usando Dio
      final dio = Dio();
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${widget.book.title}.epub';

      // Inicia o download do ePub
      await dio.download(
        widget.book.downloadUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      // 3. Abrir o ePub com EpubViewer
      VocsyEpub.setConfig(
        themeColor: Theme.of(context).primaryColor,
        identifier: "iosBook",
        scrollDirection: EpubScrollDirection.VERTICAL,
        allowSharing: true,
        enableTts: true,
        nightMode: false,
      );

      VocsyEpub.open(filePath);
    } catch (e) {
      print('Erro ao baixar ou abrir o livro: $e'); // Imprime o erro no console
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao baixar ou abrir o livro')), // Exibe mensagem de erro para o usuário
      );
    } finally {
      // Finaliza o processo de download
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
      });
    }
  }
  //Itens na tela quando clica no livro
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              widget.book.coverUrl,
              height: 200,
              width: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'by ${widget.book.author}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            if (_isDownloading)
              CircularProgressIndicator(value: _downloadProgress)
            else
              ElevatedButton(
                onPressed: _downloadAndOpenBook,
                child: const Text('Ler Livro'),
              ),
          ],
        ),
      ),
    );
  }
}