import 'dart:io';
import 'package:image/image.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/24
/// @Message :
///
class ImageUtils {
  static final ImageUtils _singleton = ImageUtils._internal();
  ImageUtils._internal();
  static ImageUtils get instance => _singleton;

  /// Create Resized Icon Image
  Image createResizedImage(int iconSize, Image image) {
    if (image.width >= iconSize) {
      return copyResize(
        image,
        width: iconSize,
        height: iconSize,
        interpolation: Interpolation.average,
      );
    } else {
      return copyResize(
        image,
        width: iconSize,
        height: iconSize,
        interpolation: Interpolation.linear,
      );
    }
  }

  Image? decodeImageFile(String filePath) {
    final image = decodeImage(File(filePath).readAsBytesSync());
    if (image == null) {
      throw Exception('Format Exception For Image => $filePath');
    }
    return image;
  }
}
