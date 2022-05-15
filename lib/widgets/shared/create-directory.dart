import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class CreateDirectory extends StatefulWidget {
  const CreateDirectory({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  State<CreateDirectory> createState() => _CreateDirectoryState();
}

class _CreateDirectoryState extends State<CreateDirectory> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Form(
        key: _keyForm,
        child: Column(
          children: <Widget>[
            TextFormField(
              textAlign: TextAlign.center,
              onSaved: (val) {
                setState(() {
                  Directory(join(widget.path, val)).createSync();
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter a folder name';
                }

                return null;
              },
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
