import 'package:flutter/material.dart';
import 'widgets/file_explorer.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FileExplorer(title: 'File Explorer'),
    );
  }
}
