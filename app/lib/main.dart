import 'package:flutter/material.dart';

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
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Stepcompare',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
              fontSize: 20,
            ),
          ),
        ),
        body: Column(
          children: const [
            Center(
              child: Text('hellos'),
            ),
          ],
        ),
      ),
    );
  }
}
