import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      home: AuthenticationScreen(),
    );
  }
}
