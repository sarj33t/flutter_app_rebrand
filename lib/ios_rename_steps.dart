import 'dart:async';
import 'dart:io';

import './file_utils.dart';

class IosRenameSteps {
  final String newPackageName;
  String? oldPackageName;
  static const String PATH_PROJECT_FILE = 'ios/Runner.xcodeproj/project.pbxproj';
  static const String PATH_INFO_PLIST_FILE = 'ios/Runner/Info.plist';

  IosRenameSteps(this.newPackageName);


  Future<void> process() async {
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
    await _replace(PATH_PROJECT_FILE);
    print('Finished updating ios bundle identifier');
  }

  Future<void> _replace(String path) async {
    await replaceInFile(path, oldPackageName, newPackageName);
  }

  /// Updates CFBundleName
  Future<void> overwriteInfoPlist(String name) async {
    final File iOSInfoPlistFile = File(PATH_INFO_PLIST_FILE);
    final List<String> lines = await iOSInfoPlistFile.readAsLines();

    bool requireChange = false;
    for (int x = 0; x < lines.length; x++) {
      String line = lines[x];
      if (line.contains('CFBundleName')) {
        requireChange = true;
        continue;
      }
      if (requireChange) {
        lines[x] = '	<string>$name</string>';
        requireChange = false;
      }
    }
    iOSInfoPlistFile.writeAsString(lines.join('\n'));
  }

}