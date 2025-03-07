import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_rebrand/src/configs/config.dart';
import 'package:flutter_app_rebrand/src/icon_generators/iOS/models/ios_icon_template.dart';
import 'package:flutter_app_rebrand/src/utils/color_utils.dart';
import 'package:flutter_app_rebrand/src/utils/image_utils.dart';
import 'package:image/image.dart';

import 'package:flutter_app_rebrand/src/constants/far_constants.dart';
import 'models/contents_image.dart';
import 'models/contents_info.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/24
/// @Message : File to handle the creation of icons for iOS platform
/// [IoSIconGenerator]
///
class IoSIconGenerator {
  IoSIconGenerator();

  /// Create the ios icons
  void createIcons(Config config) {
    final String filePath = config.iconPath;
    if (filePath.isEmpty) {
      throw Exception('Missing Image Path');
    }

    Image? image = decodeImage(File(filePath).readAsBytesSync());
    if (image == null) {
      return;
    }

    if (config.removeAlphaIOS && image.hasAlpha) {
      final backgroundColor = ColorUtils.instance.getBackgroundColor(config);
      final pixel = image.getPixel(0, 0);
      do {
        pixel.set(ColorUtils.instance.alphaBlend(pixel, backgroundColor));
      } while (pixel.moveNext());

      image = image.convert(numChannels: 3);
    }
    if (image.hasAlpha) {
      print(
        '\nWARNING: Icons with alpha channel are not allowed in the Apple App Store.\nSet "remove_alpha_ios: true" to remove it.\n',
      );
    }
    String iconName;
    final List<IosIconTemplate> generateIosIcons = FARConstants.legacyIosIcons;

    print('Overwriting default iOS launcher icon with new icon');
    for (IosIconTemplate template in generateIosIcons) {
      overwriteDefaultIcons(template, image);
    }

    for (IosIconTemplate template in FARConstants.imageSets) {
      overwriteDefaultImageSets(template, image);
    }

    iconName = FARConstants.iosDefaultIconName;
    changeIosLauncherIcon('AppIcon');
    // Still need to modify the Contents.json file
    // since the user could have added dark and tinted icons
    modifyDefaultContentsFile(iconName);
  }

  void overwriteDefaultIcons(IosIconTemplate template, Image image,
      [String iconNameSuffix = '']) {
    final Image newFile =
        ImageUtils.instance.createResizedImage(template.size, image);
    // createResizedImage(template, image);
    File('${FARConstants.iosDefaultIconFolder}${FARConstants.iosDefaultIconName}$iconNameSuffix${template.name}.png')
        .writeAsBytesSync(encodePng(newFile));
  }

  void overwriteDefaultImageSets(IosIconTemplate template, Image image,
      [String iconNameSuffix = '']) {
    final Image newFile =
        ImageUtils.instance.createResizedImage(template.size, image);
    File('${FARConstants.iosDefaultLaunchImageFolder}${FARConstants.iosDefaultLaunchImageName}$iconNameSuffix${template.name}.png')
        .writeAsBytesSync(encodePng(newFile));
  }

  /// Change the iOS launcher icon
  Future<void> changeIosLauncherIcon(String iconName) async {
    final File iOSConfigFile = File(FARConstants.iosConfigFile);
    final List<String> lines = await iOSConfigFile.readAsLines();

    bool onConfigurationSection = false;
    String? currentConfig;

    for (int x = 0; x < lines.length; x++) {
      final String line = lines[x];
      if (line.contains('/* Begin XCBuildConfiguration section */')) {
        onConfigurationSection = true;
      }
      if (line.contains('/* End XCBuildConfiguration section */')) {
        onConfigurationSection = false;
      }
      if (onConfigurationSection) {
        final match = RegExp('.*/\\* (.*)\.xcconfig \\*/;').firstMatch(line);
        if (match != null) {
          currentConfig = match.group(1);
        }

        if (currentConfig != null && line.contains('ASSETCATALOG')) {
          lines[x] = line.replaceAll(RegExp('\=(.*);'), '= $iconName;');
        }
      }
    }

    final String entireFile = '${lines.join('\n')}\n';
    await iOSConfigFile.writeAsString(entireFile,flush:true);
  }

  /// Create the Contents.json file
  void modifyContentsFile(String newIconName) {
    final String newIconFolder =
        '${FARConstants.iosAssetFolder}$newIconName.appiconset/Contents.json';
    File(newIconFolder).create(recursive: true).then((File contentsJsonFile) {
      final String contentsFileContent =
          generateContentsFileAsString(newIconName);
      contentsJsonFile.writeAsString(contentsFileContent,flush:true);
    });
  }

  /// Modify default Contents.json file
  void modifyDefaultContentsFile(String newIconName) {
    const String newIconFolder =
        '${FARConstants.iosAssetFolder}AppIcon.appiconset/Contents.json';
    File(newIconFolder).create(recursive: true).then((File contentsJsonFile) {
      final String contentsFileContent =
          generateContentsFileAsString(newIconName);
      contentsJsonFile.writeAsString(contentsFileContent,flush:true);
    });
  }

  String generateContentsFileAsString(String newIconName) {
    final List<Map<String, dynamic>> imageList;
    imageList = createLegacyImageList(newIconName);
    final Map<String, dynamic> contentJson = <String, dynamic>{
      'images': imageList,
      'info': ContentsInfoObject(version: 1, author: 'xcode').toJson(),
    };
    return json.encode(contentJson);
  }

  /// Create the image list for the Contents.json file for Xcode versions below Xcode 14
  List<Map<String, dynamic>> createLegacyImageList(String fileNamePrefix) {
    const List<Map<String, dynamic>> imageConfigurations = [
      {
        'size': '20x20',
        'idiom': 'iphone',
        'scales': ['2x', '3x']
      },
      {
        'size': '29x29',
        'idiom': 'iphone',
        'scales': ['1x', '2x', '3x']
      },
      {
        'size': '40x40',
        'idiom': 'iphone',
        'scales': ['2x', '3x']
      },
      {
        'size': '57x57',
        'idiom': 'iphone',
        'scales': ['1x', '2x']
      },
      {
        'size': '60x60',
        'idiom': 'iphone',
        'scales': ['2x', '3x']
      },
      {
        'size': '20x20',
        'idiom': 'ipad',
        'scales': ['1x', '2x']
      },
      {
        'size': '29x29',
        'idiom': 'ipad',
        'scales': ['1x', '2x']
      },
      {
        'size': '40x40',
        'idiom': 'ipad',
        'scales': ['1x', '2x']
      },
      {
        'size': '50x50',
        'idiom': 'ipad',
        'scales': ['1x', '2x']
      },
      {
        'size': '72x72',
        'idiom': 'ipad',
        'scales': ['1x', '2x']
      },
      {
        'size': '76x76',
        'idiom': 'ipad',
        'scales': ['1x', '2x']
      },
      {
        'size': '83.5x83.5',
        'idiom': 'ipad',
        'scales': ['2x']
      },
      {
        'size': '1024x1024',
        'idiom': 'ios-marketing',
        'scales': ['1x']
      },
    ];

    final List<Map<String, dynamic>> imageList = <Map<String, dynamic>>[];

    for (final config in imageConfigurations) {
      final size = config['size']!;
      final idiom = config['idiom']!;
      final List<String> scales = config['scales'];

      for (final scale in scales) {
        final filename = '$fileNamePrefix-$size@$scale.png';
        imageList.add(
          ContentsImageObject(
            size: size,
            idiom: idiom,
            filename: filename,
            scale: scale,
          ).toJson(),
        );
      }
    }
    return imageList;
  }
}
