import 'package:flutter/material.dart';
import 'src_page_reveal/material_page_reveal.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material Page Reveal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MaterialPageReveal(title: 'Material Page Reveal Home Page'),
    );
  }
}