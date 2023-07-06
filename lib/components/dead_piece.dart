import 'package:flutter/material.dart';

class DeadPiece extends StatelessWidget {
  final String imagePath;
  final bool isWhite;
  const DeadPiece({super.key, required this.imagePath, required this.isWhite});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      width: 5,
      height: 5,
      child: Image.asset(imagePath,
          color: isWhite ? Colors.white : Colors.black,
          // fit: BoxFit.cover,
          height: 5,
          width: 5),
    );
  }
}
