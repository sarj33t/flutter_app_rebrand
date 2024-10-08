library change_app_package_name;

import './android_rename_steps.dart';
import './ios_rename_steps.dart';
import 'dart:io';

class ChangeAppPackageName {
  static Future<void> start(List<String> args) async {
    // Check if there are no arguments passed
    if (args.isEmpty) {
      print('No arguments passed.');
      return;
    }

    // Variables to store package name, platform flags, and launcher icon path
    String? packageName;
    bool android = false;
    bool ios = false;
    String? launcherIconPath;

    // Track how many valid arguments have been processed
    int processedArgsCount = 0;
    
    // Loop through arguments and check for flags and values
    for (int i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--android':
          android = true;
          processedArgsCount++;
          break;
        case '--ios':
          ios = true;
          processedArgsCount++;
          break;
        case '--launcherIcon':
        // Make sure the next argument exists and is not another flag
          if (i + 1 < args.length && !args[i + 1].startsWith('--')) {
            launcherIconPath = args[++i]; // Move to next argument to get the value
            processedArgsCount += 2; // 1 for the flag and 1 for the value
          } else {
            print('Error: --launcherIcon requires a path argument.');
            return;
          }
          break;
        default:
        // The first non-flag argument is assumed to be the package name
          if (packageName == null) {
            packageName = args[i];
            processedArgsCount++;
          } else {
            print('Error: Unrecognized argument "${args[i]}".');
            return;
          }
          break;
      }
    }

    if(processedArgsCount == 1 && packageName != null){
      print('Renaming package for both Android and iOS.');
      await _renameBoth(packageName);
    }

    // Check if too many arguments have been passed
    if (processedArgsCount != args.length) {
      print('Error: Too many arguments.');
      return;
    }

    // Output results based on arguments passed
    if (packageName == null) {
      print('Error: No package name provided.');
      return;
    }

    print('Package name: $packageName');

    if (android){
      print('Renaming package for Android only.');
      await AndroidRenameSteps(packageName).process();
    }
    if (ios){
      print('Renaming package for iOS only.');
      await IosRenameSteps(packageName).process();
    }

    /// Provided Launcher Path is Not Null, hence update Icons too
    if (launcherIconPath != null) {
      print('Launcher icon path: $launcherIconPath');
      await AndroidRenameSteps(packageName).updateIcon(launcherIconPath);
    }

    // if (arguments.length == 1) {
    //   // No platform-specific flag, rename both Android and iOS
    //   print('Renaming package for both Android and iOS.');
    //   await _renameBoth(arguments[0]);
    // } else if (arguments.length == 2) {
    //   // Check for platform-specific flags
    //   var platform = arguments[1].toLowerCase();
    //   if (platform == '--android') {
    //     print('Renaming package for Android only.');
    //     await AndroidRenameSteps(arguments[0]).process();
    //   } else if (platform == '--ios') {
    //     print('Renaming package for iOS only.');
    //     await IosRenameSteps(arguments[0]).process();
    //   } else {
    //     print('Invalid argument. Use "--android" or "--ios".');
    //   }
    // } else {
    //   print('Too many arguments. This package accepts only the new package name and an optional platform flag.');
    // }
  }

  static Future<void> _renameBoth(String newPackageName) async {
    await AndroidRenameSteps(newPackageName).process();
    await IosRenameSteps(newPackageName).process();
  }
}
