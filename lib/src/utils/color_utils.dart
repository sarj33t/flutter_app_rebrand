import 'package:image/image.dart';
import 'package:flutter_app_rebrand/src/configs/config.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/24
/// @Message :
/// [ColorUtils]
///
class ColorUtils {
  static final ColorUtils _singleton = ColorUtils._internal();
  ColorUtils._internal();
  static ColorUtils get instance => _singleton;

  ColorUint8 getBackgroundColor(Config config) {
    final backgroundColorHex = config.backgroundColorIOS.startsWith('#')
        ? config.backgroundColorIOS.substring(1)
        : config.backgroundColorIOS;
    if (backgroundColorHex.length != 6) {
      throw Exception('background_color_ios hex should be 6 characters long');
    }

    final backgroundByte = int.parse(backgroundColorHex, radix: 16);
    return ColorUint8.rgba(
      (backgroundByte >> 16) & 0xff,
      (backgroundByte >> 8) & 0xff,
      (backgroundByte >> 0) & 0xff,
      0xff,
    );
  }

  Color alphaBlend(Color fg, ColorUint8 bg) {
    if (fg.format != Format.uint8) {
      fg = fg.convert(format: Format.uint8);
    }
    if (fg.a == 0) {
      return bg;
    } else {
      final invAlpha = 0xff - fg.a;
      return ColorUint8.rgba(
        (fg.a * fg.r + invAlpha * bg.g) ~/ 0xff,
        (fg.a * fg.g + invAlpha * bg.a) ~/ 0xff,
        (fg.a * fg.b + invAlpha * bg.b) ~/ 0xff,
        0xff,
      );
    }
  }
}
