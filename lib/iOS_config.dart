import 'dart:async';
import 'dart:io';

import './file_utils.dart';

class iOSConfig {
  iOSConfig();

  String? oldPackageName;
  static const String PATH_PROJECT_FILE = 'ios/Runner.xcodeproj/project.pbxproj';
  static const String PATH_INFO_PLIST_FILE = 'ios/Runner/Info.plist';

  Future<void> process(String newPackageName) async {
    print("Running for ios");
    if (!await File(PATH_PROJECT_FILE).exists()) {
      print(
          'ERROR:: project.pbxproj file not found, Check if you have a correct ios directory present in your project'
              '\n\nrun " flutter create . " to regenerate missing files.');
      return;
    }
    String? contents = await readFileAsString(PATH_PROJECT_FILE);

    var reg = RegExp(
        r'PRODUCT_BUNDLE_IDENTIFIER\s*=?\s*(.*);', caseSensitive: true,
        multiLine: false);
    var match = reg.firstMatch(contents!);
    if (match == null) {
      print(
          'ERROR:: Bundle Identifier not found in project.pbxproj file, Please file an issue on github with $PATH_PROJECT_FILE file attached.');
      return;
    }
    var name = match.group(1);
    oldPackageName = name;

    print("Old Package Name: $oldPackageName");

    print('Updating project.pbxproj File');
    await _replace(PATH_PROJECT_FILE, newPackageName);
    print('Finished updating ios bundle identifier');
  }

  Future<void> _replace(String path, String newPackageName) async {
    await replaceInFile(path, oldPackageName, newPackageName);
  }

  /// Updates CFBundleName
  Future<void> overwriteInfoPlist(String name) async {
    // Read the file as a string
    final file = File(PATH_INFO_PLIST_FILE);
    if (!file.existsSync()) {
      print('File does not exist');
      return;
    }

    String content = await file.readAsString();

    // Find the key and replace the corresponding value
    final keyToUpdate = 'CFBundleDisplayName';
    final newValue = name;

    // Example: Search for the key and its value and replace the value
    final updatedContent = content.replaceAllMapped(
      RegExp('<key>$keyToUpdate</key>\\s*<string>(.*?)</string>'),
          (match) => '<key>$keyToUpdate</key>\n\t<string>$newValue</string>',
    );

    // Write the updated content back to the file
    await file.writeAsString(updatedContent);
    print('Plist file updated successfully.');
  }

}