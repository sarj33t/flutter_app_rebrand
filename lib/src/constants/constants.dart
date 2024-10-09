import 'package:flutter_app_rebrand/src/icon_generators/android/models/android_icon_template.dart';
import 'package:flutter_app_rebrand/src/icon_generators/iOS/models/ios_icon_template.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/24
/// @Message :
///

/// iOS Specific
const String iOSProjectFile = 'ios/Runner.xcodeproj/project.pbxproj';
const String iOSPlistFile = 'ios/Runner/Info.plist';
const String iosDefaultIconFolder = 'ios/Runner/Assets.xcassets/AppIcon.appiconset/';
const String iosDefaultLaunchImageFolder = 'ios/Runner/Assets.xcassets/LaunchImage.imageset/';
const String iosAssetFolder = 'ios/Runner/Assets.xcassets/';
const String iosConfigFile = 'ios/Runner.xcodeproj/project.pbxproj';
const String iosDefaultIconName = 'Icon-App';
const String iosDefaultLaunchImageName = 'LaunchImage';
final List<IosIconTemplate> legacyIosIcons = <IosIconTemplate>[
  IosIconTemplate(name: '-20x20@1x', size: 20),
  IosIconTemplate(name: '-20x20@2x', size: 40),
  IosIconTemplate(name: '-20x20@3x', size: 60),
  IosIconTemplate(name: '-29x29@1x', size: 29),
  IosIconTemplate(name: '-29x29@2x', size: 58),
  IosIconTemplate(name: '-29x29@3x', size: 87),
  IosIconTemplate(name: '-40x40@1x', size: 40),
  IosIconTemplate(name: '-40x40@2x', size: 80),
  IosIconTemplate(name: '-40x40@3x', size: 120),
  IosIconTemplate(name: '-50x50@1x', size: 50),
  IosIconTemplate(name: '-50x50@2x', size: 100),
  IosIconTemplate(name: '-57x57@1x', size: 57),
  IosIconTemplate(name: '-57x57@2x', size: 114),
  IosIconTemplate(name: '-60x60@2x', size: 120),
  IosIconTemplate(name: '-60x60@3x', size: 180),
  IosIconTemplate(name: '-72x72@1x', size: 72),
  IosIconTemplate(name: '-72x72@2x', size: 144),
  IosIconTemplate(name: '-76x76@1x', size: 76),
  IosIconTemplate(name: '-76x76@2x', size: 152),
  IosIconTemplate(name: '-83.5x83.5@2x', size: 167),
  IosIconTemplate(name: '-1024x1024@1x', size: 1024),
];

final List<IosIconTemplate> iosIcons = <IosIconTemplate>[
  IosIconTemplate(name: '-20x20@2x', size: 40),
  IosIconTemplate(name: '-20x20@3x', size: 60),
  IosIconTemplate(name: '-29x29@2x', size: 58),
  IosIconTemplate(name: '-29x29@3x', size: 87),
  IosIconTemplate(name: '-38x38@2x', size: 76),
  IosIconTemplate(name: '-38x38@3x', size: 114),
  IosIconTemplate(name: '-40x40@2x', size: 80),
  IosIconTemplate(name: '-40x40@3x', size: 120),
  IosIconTemplate(name: '-60x60@2x', size: 120),
  IosIconTemplate(name: '-60x60@3x', size: 180),
  IosIconTemplate(name: '-64x64@2x', size: 128),
  IosIconTemplate(name: '-64x64@3x', size: 192),
  IosIconTemplate(name: '-68x68@2x', size: 136),
  IosIconTemplate(name: '-76x76@2x', size: 152),
  IosIconTemplate(name: '-83.5x83.5@2x', size: 167),
  IosIconTemplate(name: '-1024x1024@1x', size: 1024),
];

final List<IosIconTemplate> imageSets = <IosIconTemplate>[
  IosIconTemplate(name: '', size: 170),
  IosIconTemplate(name: '@2x', size: 341),
  IosIconTemplate(name: '@3x', size: 512),
];

/// Android Specific
const String androidAppBuildGradle = 'android/app/build.gradle';
const String androidManifest = 'android/app/src/main/AndroidManifest.xml';
const String androidDebugManifest = 'android/app/src/debug/AndroidManifest.xml';
const String androidProfileManifest = 'android/app/src/profile/AndroidManifest.xml';
const String androidActivityPath = 'android/app/src/main/';
const String androidDrawableResFolder = 'android/app/src/main/res';
const int androidDefaultAndroidMinSDK = 21;
const String androidFileName = 'ic_launcher.png';
const String androidDefaultIconName = 'ic_launcher';

const String androidAdaptiveForegroundFileName = 'ic_launcher_foreground.png';
const String androidAdaptiveBackgroundFileName = 'ic_launcher_background.png';
const String androidAdaptiveMonochromeFileName = 'ic_launcher_monochrome.png';

String androidResFolder() => 'android/app/src/main/res/';

String androidColorsFile() => 'android/app/src/main/res/values/colors.xml';



String androidAdaptiveXmlFolder() => '${androidResFolder()}mipmap-anydpi-v26/';

final List<AndroidIconTemplate> adaptiveForegroundIcons = <AndroidIconTemplate>[
  AndroidIconTemplate(directoryName: 'drawable-mdpi', size: 108),
  AndroidIconTemplate(directoryName: 'drawable-hdpi', size: 162),
  AndroidIconTemplate(directoryName: 'drawable-xhdpi', size: 216),
  AndroidIconTemplate(directoryName: 'drawable-xxhdpi', size: 324),
  AndroidIconTemplate(directoryName: 'drawable-xxxhdpi', size: 432),
];

final List<AndroidIconTemplate> androidIcons = <AndroidIconTemplate>[
  AndroidIconTemplate(directoryName: 'mipmap-mdpi', size: 48),
  AndroidIconTemplate(directoryName: 'mipmap-hdpi', size: 72),
  AndroidIconTemplate(directoryName: 'mipmap-xhdpi', size: 96),
  AndroidIconTemplate(directoryName: 'mipmap-xxhdpi', size: 144),
  AndroidIconTemplate(directoryName: 'mipmap-xxxhdpi', size: 192),
];