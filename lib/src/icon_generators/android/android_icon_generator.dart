import 'dart:io';
import 'package:flutter_app_rebrand/src/configs/config.dart';
import 'package:flutter_app_rebrand/src/constants/constants.dart';
import 'package:flutter_app_rebrand/src/icon_generators/android/models/android_icon_template.dart';
import 'package:flutter_app_rebrand/src/utils/image_utils.dart';
import 'package:image/image.dart';
///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/24
/// @Message :
///
class AndroidIconGenerator{
  AndroidIconGenerator();

  void createDefaultIcons(Config config) {
    print('Creating default icons Android');
    final String filePath = config.imagePath;
    if (filePath.isEmpty) {
      throw Exception('Missing Image Path');
    }
    final Image? image = ImageUtils.instance.decodeImageFile(filePath);
    if (image == null) {
      return;
    }
    final File androidManifestFile = File(androidManifest);

    print(
      'Overwriting the default Android launcher icon with a new icon',
    );
    for (AndroidIconTemplate template in androidIcons) {
      overwriteExistingIcons(
        template,
        image,
        androidFileName
      );
    }
    overwriteAndroidManifestWithNewLauncherIcon(
      androidDefaultIconName,
      androidManifestFile,
    );
  }

  /// Ensures that the Android icon name is in the correct format
  bool isAndroidIconNameCorrectFormat(String iconName) {
    // assure the icon only consists of lowercase letters, numbers and underscore
    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(iconName)) {
      throw Exception('Incorrect Icon Name');
    }
    return true;
  }


  /// Overrides the existing launcher icons in the project
  void overwriteExistingIcons(AndroidIconTemplate template, Image image, String filename) {
    final Image newFile = ImageUtils.instance.createResizedImage(template.size, image);
    File(
      '${androidResFolder()}${template.directoryName}/$filename',
    ).create(recursive: true).then((File file) {
      file.writeAsBytesSync(encodePng(newFile));
    });
  }

  /// Updates the line which specifies the launcher icon within the AndroidManifest.xml
  /// with the new icon name (only if it has changed)
  /// Note: default iconName = "ic_launcher"
  Future<void> overwriteAndroidManifestWithNewLauncherIcon(String iconName, File androidManifestFile) async {
    final List<String> oldManifestLines = (await androidManifestFile.readAsString()).split('\n');
    final List<String> transformedLines = _transformAndroidManifestWithNewLauncherIcon(oldManifestLines, iconName);
    await androidManifestFile.writeAsString(transformedLines.join('\n'));
  }

  /// Updates only the line containing android:icon with the specified iconName
  List<String> _transformAndroidManifestWithNewLauncherIcon(List<String> oldManifestLines, String iconName) {
    return oldManifestLines.map((String line) {
      if (line.contains('android:icon')) {
        // Using RegExp replace the value of android:icon to point to the new icon
        return line.replaceAll(
          RegExp(r'android:icon="[^"]*(\\"[^"]*)*"'),
          'android:icon="@mipmap/$iconName"',
        );
      } else {
        return line;
      }
    }).toList();
  }
}


