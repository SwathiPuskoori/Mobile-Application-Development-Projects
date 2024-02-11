import 'dart:convert';
import 'package:battleships/views/list_games.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:battleships/utils/sessionmanager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _verification(bool isLogin) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.length < 3 || password.length < 3) {
      _showSnackBar('Username and password must be at least 3 characters.');
      return;
    }

    final url = isLogin
        ? 'http://165.227.117.48/login'
        : 'http://165.227.117.48/register';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      _usernameController.clear();
      _passwordController.clear();
      final responseBody = jsonDecode(response.body);

      SessionManager.setSessionToken(responseBody['access_token']);
      SessionManager.setUsername(username);
      if (isLogin) {
        _showSnackBar('Login successful!');
      }
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const GameListPage(),
        ),
      );
    } else {
      final responseBody = jsonDecode(response.body);
      final errorMessage = responseBody['message'] ?? isLogin
          ? 'Login failed'
          : 'Registration failed';
      _showSnackBar(errorMessage);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Battleships Login')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username')),
              TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true),
              const SizedBox(height: 32.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                TextButton(
                    onPressed: () => _verification(true),
                    child: const Text('Log in')),
                TextButton(
                    onPressed: () => _verification(false),
                    child: const Text('Register'))
              ])
            ])));
  }

  Future<void> _checkAccessToken() async {
    final accessToken = await SessionManager.getSessionToken();
    final isValid = await _validateAccessToken(accessToken);

    if (isValid) {
      if (!mounted) return;
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const GameListPage()));
    } else {
      SessionManager.clearSession();
    }
  }

  Future<bool> _validateAccessToken(String accessToken) async {
    final response = await http.get(
      Uri.parse('http://165.227.117.48/games'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
