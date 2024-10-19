library flutter_app_rebrand;

import 'dart:convert';
import 'package:flutter_app_rebrand/src/configs/android_rebrand.dart';
import 'package:flutter_app_rebrand/src/configs/config.dart';
import 'package:flutter_app_rebrand/src/configs/ios_rebrand.dart';
import 'package:flutter_app_rebrand/src/constants/asci_constants.dart';
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
    // Check if rebrand.json file exists
    final bool fileExist = await FileUtils.instance.rebrandJSONExist();
    if (!fileExist) {
      print('${red}Error: ${FARConstants.rebrandFileKey} file not found. $reset');
      return;
    }else{
      print('${green}${checkMark} Found JSON file in project\'s root dir ${checkMark}$reset');
      print('');
      _processToRebrandApp();
    }
  }

  /// Process to rebrand the application
  static Future<void> _processToRebrandApp() async {
    try {
      final String filePath = FARConstants.rebrandFileKey;

      // Read the JSON file
      final File file = File(filePath);
      final String jsonString = await file.readAsString();

      // Decode the JSON content
      final Map<String, dynamic> config = jsonDecode(jsonString);

      // Access platform-specific information
      final Map<String, dynamic> iosConfig = config['ios']?? <String, dynamic>{};
      final Map<String, dynamic> androidConfig = config['android']?? <String, dynamic>{};

      if(iosConfig.isNotEmpty){
        // Print iOS configuration
        print('${green}iOS Configuration:${reset}');
        print('${yellow}PackageName: ${iosConfig['packageName']}${reset}');
        print('${yellow}LauncherIconPath: ${iosConfig['launcherIconPath']}${reset}');
        print('${yellow}AppName: ${iosConfig['appName']}${reset}');
        print(''); // Blank line for separation
        await _extractFields(iosConfig, TargetPlatform.ios);
      }
      if(androidConfig.isNotEmpty){
        // Print Android configuration
        print('');
        print('${green}Android Configuration:${reset}');
        print('${yellow}PackageName: ${androidConfig['packageName']}${reset}');
        print('${yellow}LauncherIconPath: ${androidConfig['launcherIconPath']}${reset}');
        print('${yellow}AppName: ${androidConfig['appName']}${reset}');
        print('');
        await _extractFields(androidConfig, TargetPlatform.android);
      }
    } catch (ex) {
      print('Error reading or parsing JSON: $ex');
    }
  }

  /// Extract Fields from JSON
  static Future<void> _extractFields(Map<String, dynamic> config, TargetPlatform platform) async{
    // Extract fields from JSON
    final String newPackageName = config[FARConstants.packageNameKey];
    final String newLauncherIcon = config[FARConstants.launcherIconPathKey];
    final String newAppName = config[FARConstants.appNameKey];

    /// Package Name Update
    if (newPackageName.isNotEmpty){
      try{
        platform == TargetPlatform.android? await AndroidRebrand.instance.process(newPackageName):
        platform == TargetPlatform.ios? await IoSRebrand.instance.process(newPackageName): null;
      } catch(ex){
        _logError(platform, ex, 'Package Name');
      };
    }

    /// Launcher Icon Update
    if (newLauncherIcon.isNotEmpty){
      final Config config = Config(iconPath: newLauncherIcon);
      try{
        platform == TargetPlatform.android? await AndroidIconGenerator().createDefaultIcons(config):
        platform == TargetPlatform.ios? await IoSIconGenerator().createIcons(config): null;
      }catch(ex){
        _logError(platform, ex, 'Launcher Icon');
      };
    }

    /// App Name Update
    if (newAppName.isNotEmpty){
      try{
        platform == TargetPlatform.android? await AndroidRebrand.instance.updateAppName(newAppName):
        platform == TargetPlatform.ios? await IoSRebrand.instance.overwriteInfoPlist(newAppName): null;
      }catch(ex){
        _logError(platform, ex, 'App Name');
      };
    }
  }

  /// Log Console Error Message
  static void _logError(TargetPlatform platform, Object ex, String property) {
    print('${red}Error occurred while updating $property for ${platform.name.toUpperCase()} \nDetails => $ex${reset}');
  }
}

/// Target Platform
enum TargetPlatform{
  android,
  ios
}
