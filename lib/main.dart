import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TicTacToeHomePage(),
    );
  }
}

class TicTacToeHomePage extends StatefulWidget {
  @override
  _TicTacToeHomePageState createState() => _TicTacToeHomePageState();
}

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
  List<String> board = List.filled(9, '');
  String Oyuncu = 'O';
  bool gameOver = false;

  int oyuncuKazandi = 0;
  int botKazandi = 0;

  void yenidenBasla() {
    setState(() {
      board = List.filled(9, '');
      Oyuncu = 'O';
      gameOver = false;
    });
  }

  void sifirla() {
    setState(() {
      oyuncuKazandi = 0;
      botKazandi = 0;
    });
  }

  void oyuncuHamle(int index) {
    if (board[index] != '' || gameOver || Oyuncu == 'X') return;

    setState(() {
      board[index] = 'O';
      if (kimKazandi('O')) {
        oyuncuKazandi++;
        gameOver = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Kazandin !'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    yenidenBasla();
                  },
                  child: Text('Yeniden Oyna'),
                ),
              ],
            );
          },
        );
      } else if (board.every((cell) => cell != '')) {
        gameOver = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Berabere !'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    yenidenBasla();
                  },
                  child: Text('Yeniden Oyna'),
                ),
              ],
            );
          },
        );
      } else {
        Oyuncu = 'X';
        botHamle();
      }
    });
  }

  void botHamle() {
    if (gameOver) return;

    List<int> availableMoves = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        availableMoves.add(i);
      }
    }

    Random random = Random();
    int move = availableMoves[random.nextInt(availableMoves.length)];

    setState(() {
      board[move] = 'X';
      if (kimKazandi('X')) {
        botKazandi++;
        gameOver = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Bot Kazandi !'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    yenidenBasla();
                  },
                  child: Text('Yeniden Oyna'),
                ),
              ],
            );
          },
        );
      } else {
        Oyuncu = 'O';
      }
    });
  }

  bool kimKazandi(String oyuncu) {
    List<List<int>> kazanmaKosullari = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var kosullar in kazanmaKosullari) {
      if (board[kosullar[0]] == oyuncu &&
          board[kosullar[1]] == oyuncu &&
          board[kosullar[2]] == oyuncu) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double boxSize = min(screenWidth, screenHeight) / 3 - 40;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Tic Tac Toe - Emir CEVIK 211141018',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              'Oyuncu: $Oyuncu',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                BorderSide borderSide = BorderSide(
                  color: Colors.white,
                  width: 3,
                );

                Border border = Border(
                  top: index < 3 ? BorderSide.none : borderSide,
                  left: index % 3 == 0 ? BorderSide.none : borderSide,
                  right: index % 3 == 2 ? BorderSide.none : borderSide,
                  bottom: index > 5 ? BorderSide.none : borderSide,
                );

                return GestureDetector(
                  onTap: () => oyuncuHamle(index),
                  child: Container(
                    width: boxSize,
                    height: boxSize,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.zero,
                      border: border,
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'Oyuncu Kazandi: $oyuncuKazandi',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              'Bot Kazandi: $botKazandi',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: yenidenBasla,
                  child: Text('Yeniden Baslat'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: sifirla,
                  child: Text('Sifirla'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
