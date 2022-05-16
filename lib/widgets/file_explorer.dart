import 'dart:io';
import 'package:filemanager/widgets/edit_file.dart';
import 'package:filemanager/widgets/shared/create_directory.dart';
import 'package:filemanager/widgets/shared/create_file.dart';
import 'package:filemanager/widgets/shared/file_item.dart';
import 'package:filemanager/widgets/shared/rename_file.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'file_details.dart';

class FileExplorer extends StatefulWidget {
  const FileExplorer({Key? key, required this.title, required this.path}) : super(key: key);

  static FileSystemEntity? copiedFile;
  static bool? cutFile;  
  final String title;
  final String path;

  @override
  State<FileExplorer> createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
  
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
            var files = snapshot.data as List<FileSystemEntity>;
            files.sort((f1, f2) => (f1 is Directory) ? -1 : 1);
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                var file = files[index];
                return FileItem(
                  file: file,
                  onOpen: () => file is File ? _openFile(context, file) : _goToDirectory(context, file),
                  onDeleteFile: () => _deleteFile(file),
                  onDetailsFile: () => _showFileDetails(context, file),
                  onCopyFile: (cutFile) => _copyFile(context, file, cutFile),
                  onPasteFile: () => _pasteFile(context, file),
                  onRenameFile: () => _showRenameFileDialog(context, file),
                );
              },
            );
          }
          return const Center(child: Text("Loading"));
        }
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  _showCreateDirectoryDialog(context);
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.create_new_folder),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                _showCreateFileDialog(context);
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.note_add),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<FileSystemEntity>> _files() async {
    var dir = Directory(widget.path);
    var files = dir.list()
      .toList();

    return files;
  }

  Future _showCreateDirectoryDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateDirectory(path: widget.path);
      }
    ).then((value) => setState(() { }));
  }

  Future _showCreateFileDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateFile(path: widget.path);
      }
    ).then((value) => setState(() { }));
  }

  Future _showRenameFileDialog(BuildContext context, FileSystemEntity file) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return RenameFile(file: file);
      }
    ).then((value) => setState(() { }));
  }

  void _goToDirectory(BuildContext context, FileSystemEntity dir) {
    Navigator.of(context)
      .push(
        MaterialPageRoute(builder: (context) {
          return FileExplorer(title: widget.title, path: dir.path);
        })
      );
  }

  void _openFile(context, file) {
    Navigator.of(context)
      .push(
        MaterialPageRoute(
          builder: (context) {
            return EditFile(title: 'Edit ${basename(file.path)}', file: file);
          }
        )
      ).then((value) => setState(() { }));
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

  void _copyFile(BuildContext context, FileSystemEntity file, bool cutFile) {
    FileExplorer.copiedFile = file;
    FileExplorer.cutFile = cutFile;
    ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          cutFile ? "File copied" : "File cutted",
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 1),
      ));
  }

  void _pasteFile(BuildContext context, FileSystemEntity destination) {
    if (FileExplorer.copiedFile is Directory) {
      destination = Directory(join(destination.absolute.path, basename(FileExplorer.copiedFile!.path)));
      (destination as Directory).createSync();
      _pasteDirectoryRecursive(FileExplorer.copiedFile as Directory, destination);
      
    } 
    else {
      var file = FileExplorer.copiedFile as File;
      var toPath = join(destination.path, basename(FileExplorer.copiedFile!.path));
      file.copySync(toPath);
    }

    if (FileExplorer.cutFile!) {
      FileExplorer.copiedFile?.deleteSync(recursive: true);
      FileExplorer.copiedFile = null;
      FileExplorer.cutFile = null;
    }

    setState(() { });
  }

  void _pasteDirectoryRecursive(Directory source, Directory destination) =>
    source.listSync(recursive: false)
      .forEach((var entity) {
        if (entity is Directory) {
          var newDirectory = Directory(join(destination.absolute.path, basename(entity.path)));
          newDirectory.createSync();
          
          _pasteDirectoryRecursive(entity.absolute, newDirectory);
        } else if (entity is File) {
          entity.copySync(join(destination.path, basename(entity.path)));
        }
  });
}