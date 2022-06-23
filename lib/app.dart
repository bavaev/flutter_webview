import 'package:flutter/material.dart';

import 'widgets/browser.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Browser App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Browser(),
    );
  }
}
