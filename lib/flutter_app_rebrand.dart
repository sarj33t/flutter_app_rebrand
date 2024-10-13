library flutter_app_rebrand;

import 'dart:convert';
import 'package:flutter_app_rebrand/src/configs/android_rebrand.dart';
import 'package:flutter_app_rebrand/src/configs/config.dart';
import 'package:flutter_app_rebrand/src/configs/ios_rebrand.dart';
import 'package:flutter_app_rebrand/src/constants/far_constants.dart';
import 'package:flutter_app_rebrand/src/icon_generators/android/android_icon_generator.dart';
import 'package:flutter_app_rebrand/src/utils/file_utils.dart';
import 'dart:io';
import 'src/icon_generators/iOS/ios_icon_generator.dart';

/// [FlutterAppRebrand]
class FlutterAppRebrand {
  /// Start the process to rebrand application with
  /// the provided rebrand.json file
  static Future<void> init(List<String> args) async {
    // Check if there are no arguments passed
    if (args.isEmpty) {
      print('No arguments passed.');
      return;
    }

    // Check if rebrand.json file exists
    final bool fileExist = await FileUtils.instance.rebrandJSONExist();
    if (!fileExist) {
      print('Error: ${FARConstants.rebrandFileKey} file not found.');
      return;
    }
    _processToRebrandApp();
  }

  /// Process to rebrand the application
  static Future<void> _processToRebrandApp() async {
    try {
      // Parse the JSON
      final String contents =
          await File(FARConstants.rebrandFileKey).readAsString();
      final data = jsonDecode(contents);

      assert(data[FARConstants.packageNameKey] is String,
          FARConstants.packageNameStringError);
      assert(data[FARConstants.launcherIconPathKey] is String,
          FARConstants.launcherIconPathStringError);
      assert(data[FARConstants.appNameKey] is String,
          FARConstants.appNameStringError);

      // Extract fields from JSON
      final String newPackageName = data[FARConstants.packageNameKey];
      final String newLauncherIcon = data[FARConstants.launcherIconPathKey];
      final String newAppName = data[FARConstants.appNameKey];

      if (newPackageName.isNotEmpty) {
        await AndroidRebrand.instance.process(newPackageName);
        await IoSRebrand.instance.process(newPackageName);
      }
      if (newLauncherIcon.isNotEmpty) {
        final config = Config(iconPath: newLauncherIcon);
        IoSIconGenerator().createIcons(config);
        AndroidIconGenerator().createDefaultIcons(config);
      }
      if (newAppName.isNotEmpty) {
        await AndroidRebrand.instance.updateAppName(newAppName);
        await IoSRebrand.instance.overwriteInfoPlist(newAppName);
      }
    } catch (ex) {
      print('Error reading or parsing JSON: $ex');
    }
  }
}
