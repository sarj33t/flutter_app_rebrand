import 'dart:io';

/// [FileUtils]
class FileUtils{
  static final FileUtils _singleton = FileUtils._internal();
  FileUtils._internal();
  static FileUtils get instance => _singleton;

  Future<void> replaceInFile(String path, oldPackage, newPackage) async {
    String? contents = await readFileAsString(path);
    if(contents == null){
      print('ERROR:: file at $path not found');
      return;
    }
    contents = contents.replaceAll(oldPackage, newPackage);
    await writeFileFromString(path, contents);
  }

  Future<void> replaceInFileRegex(String path, regex, replacement) async {
    String? contents = await readFileAsString(path);
    if(contents == null){
      print('ERROR:: file at $path not found');
      return;
    }
    contents = contents.replaceAll(RegExp(regex), replacement);
    await writeFileFromString(path, contents);
  }

  Future<String?> readFileAsString(String path) async {
    var file = File(path);
    String? contents;

    if (await file.exists()) {
      contents = await file.readAsString();
    }
    return contents;
  }

  Future<void> writeFileFromString(String path, String contents) async {
    var file = File(path);
    await file.writeAsString(contents);
  }
}


