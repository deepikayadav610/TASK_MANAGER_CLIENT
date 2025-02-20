import 'package:flutter/material.dart';
import './screens/home_page.dart';

void main() {
  runApp(const ManageTaskApp());
}

class ManageTaskApp extends StatelessWidget {
  const ManageTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}
