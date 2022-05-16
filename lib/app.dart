import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
      home: FutureBuilder(
        future: _rootPath(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String path = snapshot.data;
            return FileExplorer(title: 'File Explorer', path: path);
          }
          return const Center(child: Text("Loading"));
        }
      ),
      
    );
  }

  Future<String> _rootPath() async {
    var dir = await getExternalStorageDirectory();
    return dir!.path;
  }
}
