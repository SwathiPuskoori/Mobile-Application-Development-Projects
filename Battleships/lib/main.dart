import 'package:battleships/views/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Battleships',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen()));
}
