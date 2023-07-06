import 'package:chess/components/dead_piece.dart';
import 'package:chess/components/piece.dart';
import 'package:chess/components/square.dart';
import 'package:chess/helper/helper_method.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // A 2D array of ChessPiece
  late List<List<ChessPiece?>> board;

  // The currently selected piece on the board
  // If no piece is selected, this is null
  ChessPiece? selectedPiece;

  // The row index of the selected piece
  // Default value is -1 indicating no piece is currently selected
  int selectedRow = -1;

  // The column index of the selected piece
  // Default value is -1 indicating no piece is currently selected
  int selectedCol = -1;

  // a list of valid moves for currently selected piece
  // each move is represented as a list with 2 elements: row and column
  List<List<int>> validMoves = [];

  // A list of white pieces that have been taken by the black player
  List<ChessPiece> whiteTakenPieces = [];

  // A list of black pieces that have been taken by the white player
  List<ChessPiece> blackTakenPieces = [];

  // A boolean to see the turn
  bool isWhiteTurn = true;

  // initial position of the kings
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;

  void initializeBoard() {
    List<List<ChessPiece?>> newBoard = List.generate(8, (row) {
      return List.generate(8, (column) {
        return null;
      });
    });
    // place random pieces in middle of board
    // newBoard[3][3] = const ChessPiece(
    //   type: ChessPieceType.bishop,
    //   isWhite: false,
    //   imagePath: 'assets/images/bishop.png',
    // );

    // place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = const ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: false,
        imagePath: 'assets/images/chess-pawn.png',
      );
    }
    for (int i = 0; i < 8; i++) {
      newBoard[6][i] = const ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: 'assets/images/chess-pawn.png',
      );
    }

    // place rooks
    newBoard[0][0] = const ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'assets/images/rook.png',
    );
    newBoard[0][7] = const ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'assets/images/rook.png',
    );
    newBoard[7][0] = const ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'assets/images/rook.png',
    );
    newBoard[7][7] = const ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'assets/images/rook.png',
    );

    // place knights
    newBoard[0][1] = const ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'assets/images/chess.png',
    );
    newBoard[0][6] = const ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'assets/images/chess.png',
    );
    newBoard[7][1] = const ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'assets/images/chess.png',
    );
    newBoard[7][6] = const ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'assets/images/chess.png',
    );

    // place bishops
    newBoard[0][2] = const ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'assets/images/bishop.png',
    );
    newBoard[0][5] = const ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'assets/images/bishop.png',
    );
    newBoard[7][2] = const ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'assets/images/bishop.png',
    );
    newBoard[7][5] = const ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'assets/images/bishop.png',
    );

    // place queens
    newBoard[0][3] = const ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: 'assets/images/queen.png',
    );
    newBoard[7][3] = const ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: 'assets/images/queen.png',
    );

    // place kings
    newBoard[0][4] = const ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: 'assets/images/king.png',
    );
    newBoard[7][4] = const ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: 'assets/images/king.png',
    );

    setState(() {
      board = newBoard;
    });
  }

  // user selected a piece
  void pieceSelected(int row, int col) {
    setState(() {
      // selected a piece if there is a piece at the selected square or position
      // if (board[row][col] != null) {
      //   selectedPiece = board[row][col];
      //   selectedRow = row;
      //   selectedCol = col;
      // }
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite != isWhiteTurn) {
          return;
        }
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      } else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }

      // if there is piece selected and user taps on a square that is not selected
      // check if the square is a valid move
      // if it is a valid move, move the piece to the new square
      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }

      // if a piece is selected, calculate it's valid moves
      if (selectedPiece != null) {
        validMoves = calculateValidMoves(row, col, selectedPiece!);
      }
    });
  }

// calculate valid moves for a piece
  List<List<int>> calculateValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    int direction = piece!.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        // check if the square in front of the pawn is empty
        // if empty, add it to the list of valid moves
        // if not empty, stop checking
        // pawns can move 2 squares forward if they haven't moved yet
        // pawns can move diagonally if they are capturing an opponent's piece

        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }

        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }

        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        break;
      case ChessPieceType.rook:
        // horizontal and vertical moves
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] == null) {
              candidateMoves.add([newRow, newCol]);
            } else {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            i++;
          }
        }

        break;
      case ChessPieceType.knight:
        // all eight possible L shapes the knight can move
        var knightMoves = [
          [-2, -1], //up 2 left 1
          [-2, 1], //up 2 right 1
          [-1, -2], //up 1 left 2
          [-1, 2], //up 1 right 2
          [1, -2], //down 1 left 2
          [1, 2], //down 1 right 2
          [2, -1], //down 2 left 1
          [2, 1], //down 2 right 1
        ];

        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (isInBoard(newRow, newCol)) {
            if (board[newRow][newCol] == null) {
              candidateMoves.add([newRow, newCol]);
            } else {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
            }
          }
        }

        break;
      case ChessPieceType.bishop:
        // diagonal moves
        var directions = [
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] == null) {
              candidateMoves.add([newRow, newCol]);
            } else {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            i++;
          }
        }

        break;
      case ChessPieceType.queen:
        // horizontal, vertical and diagonal moves
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] == null) {
              candidateMoves.add([newRow, newCol]);
            } else {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        // all 8 squares around the king
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];

        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (isInBoard(newRow, newCol)) {
            if (board[newRow][newCol] == null) {
              candidateMoves.add([newRow, newCol]);
            } else {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
            }
          }
        }

        break;
      default:
    }
    return candidateMoves;
  }

  // calculate real valid moves
  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateValidMoves(row, col, piece);

    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];
        if (simulatedMoveIsSafe(piece!, row, endRow, col, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int endRow, int startCol, int endCol) {
    // save the current board state
    ChessPiece? originalDestinationPiece = board[endRow][endCol];
    // if the piece is king, save the king's position

    List<int>? originalKingPosition;
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        originalKingPosition = whiteKingPosition;
      } else {
        originalKingPosition = blackKingPosition;
      }

      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }
    // similate the move
    board[startRow][startCol] = null;
    board[endRow][endCol] = piece;

    // check if the king is under attack
    bool kingInCheck = !isKingCheck(piece.isWhite);

    // restore the board state
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;

    // if the piece was the king, restore the king's position
    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    return !kingInCheck;
  }

  void movePiece(int row, int col) {
    // if the new spot has an enemy piece
    if (board[row][col] != null) {
      // add the enemy piece to the list of taken pieces
      if (board[row][col]!.isWhite) {
        whiteTakenPieces.add(board[row][col]!);
      } else {
        blackTakenPieces.add(board[row][col]!);
      }
    }

    // check if the piece is a king
    if (selectedPiece!.type == ChessPieceType.king) {
      // update the position of the king
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [row, col];
      } else {
        blackKingPosition = [row, col];
      }
    }
    // move the piece to the new square
    board[selectedRow][selectedCol] = null;
    board[row][col] = selectedPiece;

    // see if king is under attack
    if (isKingCheck(!isWhiteTurn)) {
      // if king is under attack
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    // change the turn
    isWhiteTurn = !isWhiteTurn;
  }

  bool isKingCheck(bool isWhiteKing) {
    // get the position of king
    List<int> kingPosition =
        isWhiteKing == 1 ? whiteKingPosition : blackKingPosition;
    // check if any of the opponent's pieces can attack the king
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (board[row][col] != null &&
            board[row][col]!.isWhite != isWhiteKing) {
          List<List<int>> validMoves =
              calculateValidMoves(row, col, board[row][col]);
          if (validMoves.any((move) =>
              move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
            return true;
          }
        }
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    initializeBoard();
  }

  // create a piece
  ChessPiece? myPawn = const ChessPiece(
    type: ChessPieceType.pawn,
    isWhite: true,
    imagePath: 'assets/images/chess-pawn.png',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // white taken pieces
          Expanded(
              // flex: 1,
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: whiteTakenPieces.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8, childAspectRatio: 1.4),
                  itemBuilder: (context, index) => DeadPiece(
                      imagePath: whiteTakenPieces[index].imagePath,
                      isWhite: whiteTakenPieces[index].isWhite))),

          Text('Turn: ${isWhiteTurn ? 'White' : 'Black'}'),
          Text('${isKingCheck(isWhiteTurn) ? 'Check' : ''}'),
          Expanded(
            flex: 4,
            child: GridView.builder(
                itemCount: 8 * 8,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int column = index % 8;

                  // check if this square is selected
                  bool isSelected = selectedRow == row && selectedCol == column;

                  bool isValidMove = false;
                  for (int i = 0; i < validMoves.length; i++) {
                    if (validMoves[i][0] == row && validMoves[i][1] == column) {
                      isValidMove = true;
                      break;
                    }
                  }

                  return Square(
                      isWhite: isWhite(index),
                      piece: board[row][column],
                      isSelected: isSelected,
                      isValidMove: isValidMove,
                      onTap: () {
                        // (board[row][column] == null)
                        //     ? null
                        // :
                        pieceSelected(row, column);
                      });
                }),
          ),
          Expanded(
              // flex: 3,
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: blackTakenPieces.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    childAspectRatio: 1.4,
                  ),
                  itemBuilder: (context, index) => DeadPiece(
                      imagePath: blackTakenPieces[index].imagePath,
                      isWhite: blackTakenPieces[index].isWhite))),
        ],
      ),
    );
  }
}
