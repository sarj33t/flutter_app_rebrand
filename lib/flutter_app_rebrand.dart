library flutter_app_rebrand;

import 'dart:convert';
import './android_config.dart';
import './iOS_config.dart';
import 'dart:io';

/// [FlutterAppRebrand]
class FlutterAppRebrand {
  static Future<void> init(List<String> args) async {
    // Check if there are no arguments passed
    if (args.isEmpty) {
      print('No arguments passed.');
      return;
    }

    final filePath = args[0];

    // Read the file content
    final file = File(filePath);
    if (!file.existsSync()) {
      print('File does not exist');
      return;
    }

    try {
      // Parse the JSON
      final contents = await file.readAsString();
      final data = jsonDecode(contents);

      // Extract fields from JSON
      final newPackageName = data['package_name'];
      final newLauncherIcon = data['launcher_icon'];
      final newAppTitle = data['app_label'];

      await AndroidConfig().process(newPackageName);
      await iOSConfig().process(newPackageName);

      await AndroidConfig().updateIcon(newLauncherIcon);
      await AndroidConfig().updateAppName(newAppTitle);
      await iOSConfig().overwriteInfoPlist(newAppTitle);
    } catch (ex) {
      print('Error reading or parsing JSON: $ex');
    }
  }
}
