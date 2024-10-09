library flutter_app_rebrand;

import 'dart:convert';
import 'package:flutter_app_rebrand/src/configs/android_rebrand.dart';
import 'package:flutter_app_rebrand/src/configs/config.dart';
import 'package:flutter_app_rebrand/src/configs/iOS_rebrand.dart';
import 'package:flutter_app_rebrand/src/icon_generators/android/android_icon_generator.dart';
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
    const filePath = 'rebrand.json';
    final rebrandFile = File(filePath);

    if (!await rebrandFile.exists()) {
      print('Error: rebrand.json file not found.');
      return;
    }

    try {
      // Parse the JSON
      final contents = await rebrandFile.readAsString();
      final data = jsonDecode(contents);

      assert(data['bundleId'] is String, 'BundleId must be String');
      assert(data['iconPath'] is String, 'IconPath must be String');
      assert(data['appName'] is String, 'AppName must be String');

      // Extract fields from JSON
      final String newBundleId = data['bundleId'];
      final String newIcon = data['iconPath'];
      final String newAppName = data['appName'];

      if (newBundleId.isNotEmpty) {
        await AndroidRebrand().process(newBundleId);
        await IoSRebrand().process(newBundleId);
      }
      if(newIcon.isNotEmpty){
        final config = Config(
          imagePath: newIcon
        );
        IoSIconGenerator().createIcons(
          config
        );
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
