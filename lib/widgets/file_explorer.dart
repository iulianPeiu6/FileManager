import 'dart:io';
import 'package:filemanager/widgets/shared/file_item.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'file_details.dart';

class FileExplorer extends StatefulWidget {
  const FileExplorer({Key? key, required this.title, required this.path}) : super(key: key);

  final String title;
  final String path;

  @override
  State<FileExplorer> createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
  final GlobalKey<FormState> _keyDialogForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _files(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                return FileItem(
                  file: snapshot.data[index],
                  onTap: () => _goToDirectory(context, snapshot.data[index]),
                  onDeleteFile: () => _deleteFile(snapshot.data[index]),
                  onDetailsFile: () => _showFileDetails(context, snapshot.data[index])
                );
              },
            );
          }
          return const Center(child: Text("Loading"));
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showCreateDirectoryDialog(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }

  Future _showCreateDirectoryDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Form(
              key: _keyDialogForm,
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
                  if (_keyDialogForm.currentState!.validate()) {
                    _keyDialogForm.currentState!.save();
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
        });
  }
 
  Future<List<FileSystemEntity>> _files() async {
    var dir = Directory(widget.path);
    var files = dir.list().toList();
    return files;
  }

  void _goToDirectory(BuildContext context, FileSystemEntity dir) {
    Navigator.of(context)
      .push(
        MaterialPageRoute(builder: (context) {
          return FileExplorer(title: widget.title, path: dir.path);
        })
      );
  }

  void _showFileDetails(BuildContext context, FileSystemEntity file) {
    Navigator.of(context)
      .push(
        MaterialPageRoute(builder: (context) {
          return FileDetails(title: "File Details", file: file);
        })
      );
  }

  void _deleteFile(FileSystemEntity file) {
    setState(() {
      file.deleteSync(recursive: true);
    });
  }
}