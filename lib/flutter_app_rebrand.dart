library flutter_app_rebrand;

import 'dart:convert';
import 'package:flutter_app_rebrand/src/configs/android_rebrand.dart';
import 'package:flutter_app_rebrand/src/configs/config.dart';
import 'package:flutter_app_rebrand/src/configs/iOS_rebrand.dart';
import 'package:flutter_app_rebrand/src/constants/far_constants.dart';
import 'package:flutter_app_rebrand/src/icon_generators/android/android_icon_generator.dart';
import 'package:flutter_app_rebrand/src/utils/file_utils.dart';
import 'dart:io';
import 'src/icon_generators/iOS/ios_icon_generator.dart';

/// [FlutterAppRebrand]
class FlutterAppRebrand {
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
  static Future<void> _processToRebrandApp() async{
    try {
      // Parse the JSON
      final String contents = await File(FARConstants.rebrandFileKey).readAsString();
      final data = jsonDecode(contents);

      assert(data[FARConstants.packageNameKey] is String, 'Package name must be String');
      assert(data[FARConstants.launcherIconPathKey] is String, 'Launcher Icon path must be String');
      assert(data[FARConstants.appNameKey] is String, 'App Name must be String');

      // Extract fields from JSON
      final String newPackageName = data[FARConstants.packageNameKey];
      final String newLauncherIcon = data[FARConstants.launcherIconPathKey];
      final String newAppName = data[FARConstants.appNameKey];

      if (newPackageName.isNotEmpty) {
        await AndroidRebrand().process(newPackageName);
        await IoSRebrand().process(newPackageName);
      }
      if(newLauncherIcon.isNotEmpty){
        final config = Config(
            imagePath: newLauncherIcon
        );
        IoSIconGenerator().createIcons(config);
        AndroidIconGenerator().createDefaultIcons(config);
      }
      if(newAppName.isNotEmpty){
        await AndroidRebrand().updateAppName(newAppName);
        await IoSRebrand().overwriteInfoPlist(newAppName);
      }
    } catch (ex) {
      print('Error reading or parsing JSON: $ex');
    }
  }
}
