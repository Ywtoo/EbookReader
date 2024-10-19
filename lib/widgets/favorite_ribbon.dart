import 'package:flutter/material.dart';

class FavoriteRibbon extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const FavoriteRibbon({Key? key, required this.isFavorite, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8.0,
      right: 8.0,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          isFavorite ? Icons.bookmark : Icons.bookmark_border,
          color: isFavorite ? Colors.red : Colors.grey,
          size: 24.0,
        ),
      ),
    );
  }
}