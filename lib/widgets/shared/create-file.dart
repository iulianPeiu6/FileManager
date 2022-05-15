import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class CreateFile extends StatefulWidget {
  const CreateFile({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  State<CreateFile> createState() => _CreateFileState();
}

class _CreateFileState extends State<CreateFile> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String filename = "";
    String fileContent = "";
    return AlertDialog(
          title: Form(
            key: _keyForm,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "NewFile",
                      contentPadding: EdgeInsets.only(left: 14, right: 14),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent, width: 4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 4),
                      ),
                    ),
                    onSaved: (val) {
                      filename = val!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a file name';
                      }

                      return null;
                    },
                  ),
                ),
                TextFormField(
                  //textAlign: TextAlign.center,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: "Add here the file content ...",
                    contentPadding: EdgeInsets.only(left: 14, right: 14, top: 24, bottom: 14),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.greenAccent, width: 4),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 4),
                    ),
                  ),
                  onSaved: (val) {
                    fileContent = val!;
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
                  setState(() {
                    var file = File(join(widget.path, filename));
                    file.createSync();
                    file.writeAsStringSync(fileContent);
                  });
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
