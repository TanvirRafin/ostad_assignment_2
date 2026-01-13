import 'package:flutter/material.dart';
import 'main screen.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Music Player',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyApp(),
    );
  }
}
