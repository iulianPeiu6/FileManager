import 'dart:io';

import 'package:flutter/material.dart';

class FileDetails extends StatefulWidget {
  const FileDetails({Key? key, required this.title, required this.file}) : super(key: key);

  final String title;
  final FileSystemEntity file;

  @override
  State<FileDetails> createState() => _FileDetailsState();
}

class _FileDetailsState extends State<FileDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Text(widget.file.path)
    );
  }
}
