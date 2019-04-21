import 'package:flutter/material.dart';
import 'src_page_reveal/material_page_reveal.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MaterialPageReveal(title: 'Flutter Demo Home Page'),
    );
  }
}