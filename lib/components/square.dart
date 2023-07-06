import 'package:chess/components/piece.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;

  const Square(
      {super.key,
      required this.isWhite,
      required this.piece,
      required this.isSelected,
      required this.isValidMove,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

    // if selected, square is highlighted green
    if (isSelected) {
      squareColor = Colors.green;
    } else if (isValidMove) {
      squareColor = Colors.green[200];
    } else {
      // if not selected, square is either white or black
      squareColor = isWhite ? foregroundColor : backgroundColor;
    }

    // otherwise, square is either white or black

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValidMove ? 8 : 0),
        child: piece != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  piece!.imagePath,
                  color: piece!.isWhite
                      ? Color.fromARGB(255, 243, 243, 243)
                      : Colors.black,
                  // fit: BoxFit.cover,
                ),
              )
            : null,
      ),
    );
  }
}
