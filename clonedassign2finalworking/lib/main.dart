import 'package:flutter/material.dart';
import 'views/yahtzee.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Yahtzee',
      debugShowCheckedModeBanner: false,
      home: Center(
        child: Yahtzee(),
      ),
    ),
  );
}
