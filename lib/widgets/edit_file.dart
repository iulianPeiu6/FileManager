import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class EditFile extends StatefulWidget {
  const EditFile({Key? key, required this.title, required this.file}) : super(key: key);

  final String title;
  final FileSystemEntity file;

  @override
  State<EditFile> createState() => _EditFileState();
}

class _EditFileState extends State<EditFile> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String fileContent = "";
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Form(
        key: _keyForm,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: TextFormField(
            initialValue: (widget.file as File).readAsStringSync(),
            maxLines: 100,
            onSaved: (val) {
              fileContent = val!;
            },
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.greenAccent, width: 4),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 4),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _keyForm.currentState!.save();
          (widget.file as File).writeAsStringSync(fileContent);
          Navigator.pop(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.save),
      ),
    );
  }
}
