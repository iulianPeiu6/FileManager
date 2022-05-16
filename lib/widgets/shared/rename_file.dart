import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class RenameFile extends StatefulWidget {
  const RenameFile({Key? key, required this.file}) : super(key: key);

  final FileSystemEntity file;

  @override
  State<RenameFile> createState() => _RenameFileState();
}

class _RenameFileState extends State<RenameFile> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Form(
        key: _keyForm,
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: basename(widget.file.path),
              onSaved: (val) {
                setState(() {
                  var path = widget.file.path;
                  var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
                  var newPath = path.substring(0, lastSeparator + 1) + val!;
                  widget.file.renameSync(newPath);
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'File/directory name is required';
                }

                return null;
              },
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 4),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 4),
                ),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (_keyForm.currentState!.validate()) {
              _keyForm.currentState!.save();
              Navigator.pop(context);
            }
          },
          child: const Text('Save')
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
      ],
    );
  }
}
