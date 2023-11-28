import 'package:flutter/material.dart';
import 'client_screen.dart';
import 'master_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  List<Map<String, String>> users = [
    {'username': 'client', 'password': '2', 'role': 'client'},
    {'username': 'master', 'password': '1', 'role': 'master'},
  ];

  void _login() {
    var user = users.firstWhere(
      (user) =>
          user['username'] == _usernameController.text &&
          user['password'] == _passwordController.text,
      orElse: () => {'username': '', 'password': '', 'role': ''}, 
    );

    if (user['username'] != '') {
      if (user['role'] == 'client') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClientScreen(username: user['username']!)),
        );
      } else if (user['role'] == 'master') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MasterScreen(username: user['username']!)),
        );
      }
    } else {
      print('Пользователь не найден');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вход'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Логин'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Пароль'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
