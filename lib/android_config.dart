import 'dart:async';
import 'dart:io';

import './file_utils.dart';

class AndroidConfig {
  String? oldPackageName;

  static const String PATH_BUILD_GRADLE = 'android/app/build.gradle';
  static const String PATH_MANIFEST = 'android/app/src/main/AndroidManifest.xml';
  static const String PATH_MANIFEST_DEBUG = 'android/app/src/debug/AndroidManifest.xml';
  static const String PATH_MANIFEST_PROFILE = 'android/app/src/profile/AndroidManifest.xml';
  static const String PATH_ACTIVITY = 'android/app/src/main/';
  static const String PATH_DRAWABLE_RES = 'android/app/src/main/res';

  AndroidConfig();

  // Path to your Flutter project's Android res directory
  final resDirectory = Directory(PATH_DRAWABLE_RES);

  // List of folders where the ic_launcher.png file should be replaced
  final directories = [
    'drawable',
    'drawable-v21',
    'mipmap-hdpi',
    'mipmap-mdpi',
    'mipmap-xhdpi',
    'mipmap-xxhdpi',
    'mipmap-xxxhdpi'
  ];

  Future<void> process(String newPackageName) async {
    print("Running for android");
    if (!await File(PATH_BUILD_GRADLE).exists()) {
      print('ERROR:: build.gradle file not found, Check if you have a correct android directory present in your project'
          '\n\nrun " flutter create . " to regenerate missing files.');
      return;
    }
    String? contents = await readFileAsString(PATH_BUILD_GRADLE);

    var reg = RegExp(r'applicationId\s*=?\s*"(.*)"', caseSensitive: true, multiLine: false);
    var match = reg.firstMatch(contents!);
    if(match == null) {
      print('ERROR:: applicationId not found in build.gradle file, Please file an issue on github with $PATH_BUILD_GRADLE file attached.');
      return;
    }
    var name = match.group(1);
    oldPackageName = name;

    print("Old Package Name: $oldPackageName");

    print('Updating build.gradle File');
    await _replace(PATH_BUILD_GRADLE, newPackageName);

    var mText = 'package="$newPackageName">';
    var mRegex = '(package=.*)';

    print('Updating Main Manifest file');
    await replaceInFileRegex(PATH_MANIFEST, mRegex, mText);

    print('Updating Debug Manifest file');
    await replaceInFileRegex(PATH_MANIFEST_DEBUG, mRegex, mText);

    print('Updating Profile Manifest file');
    await replaceInFileRegex(PATH_MANIFEST_PROFILE, mRegex, mText);

    await updateMainActivity(newPackageName);
    print('Finished updating android package name');
  }

  Future<void> updateMainActivity(String newPackageName) async {
    var path = await findMainActivity(type: 'java');
    if (path != null) {
      processMainActivity(path, 'java', newPackageName);
    }

    path = await findMainActivity(type: 'kotlin');
    if (path != null) {
      processMainActivity(path, 'kotlin', newPackageName);
    }
  }

  Future<void> processMainActivity(File path, String type, String newPackageName) async {
    var extension = type == 'java' ? 'java' : 'kt';
    print('Project is using $type');
    print('Updating MainActivity.$extension');
    await replaceInFileRegex(
        path.path, r'^(package (?:\.|\w)+)', "package ${newPackageName}");

    String newPackagePath = newPackageName.replaceAll('.', '/');
    String newPath = '${PATH_ACTIVITY}${type}/$newPackagePath';

    print('Creating New Directory Structure');
    await Directory(newPath).create(recursive: true);
    await path.rename(newPath + '/MainActivity.$extension');

    print('Deleting old directories');

    await deleteEmptyDirs(type);
  }

  Future<void> _replace(String path, String newPackageName) async {
    await replaceInFile(path, oldPackageName, newPackageName);
  }

  /// Delete .DStore file for macOS & Empty dirs
  Future<void> deleteEmptyDirs(String type) async {
    var dirs = await dirContents(Directory(PATH_ACTIVITY + type));
    dirs = dirs.reversed.toList();
    for (var dir in dirs) {
      if (dir is Directory) {
        // Recursively search for and delete .DS_Store files
        dir.listSync(recursive: true).forEach((entity) {
          if (entity is File && entity.uri.pathSegments.last == '.DS_Store') {
            try {
              entity.deleteSync();
              print('Deleted: ${entity.path}');
            } catch (ex) {
              print('Error deleting file: ${entity.path}, Error: $ex');
            }
          }
        });
        
        /// Proceed to delete empty dirs
        if(dir.listSync().isEmpty){
          try{
            dir.deleteSync();
          }catch(ex){
            print('Error deleting dir: $dir, Error: $ex');
          }
        }
      }
    }
  }

  Future<File?> findMainActivity({String type = 'java'}) async {
    var files = await dirContents(Directory(PATH_ACTIVITY + type));
    String extension = type == 'java' ? 'java' : 'kt';
    for (var item in files) {
      if (item is File) {
        if (item.path.endsWith('MainActivity.' + extension)) {
          return item;
        }
      }
    }
    return null;
  }

  Future<List<FileSystemEntity>> dirContents(Directory dir) {
    if(!dir.existsSync()) return Future.value([]);
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: true);
    lister.listen((file) => files.add(file),
        // should also register onError
        onDone: () => completer.complete(files));
    return completer.future;
  }

  /// Updates Launcher Icons under drawable dirs
  Future<void> updateIcon(String path) async{
    final newImageFile = File(path);
    // Replace ic_launcher.png in all the specified directories
    for (var dir in directories) {
      final targetPath = '${resDirectory.path}/$dir/ic_launcher.png';
      final targetFile = File(targetPath);
      if (targetFile.existsSync()) {
        print('Replacing $targetPath');
        // Replace the existing file with the new image
        newImageFile.copySync(targetPath);
      } else {
        print('File not found: $targetPath');
      }
    }
  }

  /// Updates App Label
  Future<void> updateAppName(String name) async {
    final File androidManifestFile = File(PATH_MANIFEST);
    final List<String> lines = await androidManifestFile.readAsLines();
    for (int x = 0; x < lines.length; x++) {
      String line = lines[x];
      if (line.contains('android:label')) {
        line = line.replaceAll(RegExp(r'android:label="[^"]*(\\"[^"]*)*"'),
          'android:label="$name"');
        lines[x] = line;
        lines.add('');
      }
    }
    androidManifestFile.writeAsString(lines.join('\n'));
  }
}
