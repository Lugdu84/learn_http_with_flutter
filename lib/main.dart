import 'package:flutter/material.dart';
import 'package:learn_http/view/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color.fromARGB(200, 110, 20, 30),
          brightness: Brightness.light),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color.fromARGB(200, 110, 20, 30),
          brightness: Brightness.dark),
      home: const Home(),
    );
  }
}
