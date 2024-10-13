import 'dart:async';
import 'dart:io';
import 'package:flutter_app_rebrand/src/constants/far_constants.dart';
import 'package:flutter_app_rebrand/src/utils/file_utils.dart';

/// [IoSRebrand]
///
class IoSRebrand {
  static final IoSRebrand _singleton = IoSRebrand._internal();
  IoSRebrand._internal();
  static IoSRebrand get instance => _singleton;

  Future<void> process(String newPackageName) async {
    print("Running for ios");
    if (!await File(FARConstants.iOSProjectFile).exists()) {
      print('ERROR:: project.pbxproj file not found, '
          'Check if you have a correct ios directory present in your project'
          '\n\nrun " flutter create . " to regenerate missing files.');
      return;
    }
    String? contents =
        await FileUtils.instance.readFileAsString(FARConstants.iOSProjectFile);

    var reg = RegExp(r'PRODUCT_BUNDLE_IDENTIFIER\s*=?\s*(.*);',
        caseSensitive: true, multiLine: false);
    var match = reg.firstMatch(contents!);
    if (match == null) {
      print('ERROR:: Bundle Identifier not found in project.pbxproj file, '
          'Please file an issue on github with ${FARConstants.iOSProjectFile} '
          'file attached.');
      return;
    }
    var name = match.group(1);
    final String? oldPackageName = name;

    print("Old Package Name: $oldPackageName");

    print('Updating project.pbxproj File');
    await _replace(FARConstants.iOSProjectFile, newPackageName, oldPackageName);
    print('Finished updating ios bundle identifier');
  }

  Future<void> _replace(
      String path, String newPackageName, String? oldPackageName) async {
    await FileUtils.instance
        .replaceInFile(path, oldPackageName, newPackageName);
  }

  /// Updates CFBundleName
  Future<void> overwriteInfoPlist(String name) async {
    // Read the file as a string
    final File file = File(FARConstants.iOSPlistFile);
    if (!file.existsSync()) {
      print('File does not exist');
      return;
    }

    final String content = await file.readAsString();

    // Find the key and replace the corresponding value
    const String keyToUpdate = 'CFBundleDisplayName';
    final String newValue = name;

    // Example: Search for the key and its value and replace the value
    final String updatedContent = content.replaceAllMapped(
      RegExp('<key>$keyToUpdate</key>\\s*<string>(.*?)</string>'),
      (match) => '<key>$keyToUpdate</key>\n\t<string>$newValue</string>',
    );

    // Write the updated content back to the file
    await file.writeAsString(updatedContent);
    print('Plist file updated successfully.');
  }
}