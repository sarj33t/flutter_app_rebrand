import 'contents_image_appearance.dart';

///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/24
/// @Message :
/// [ContentsImageObject]
class ContentsImageObject {
  ContentsImageObject({
    required this.size,
    required this.idiom,
    required this.filename,
    required this.scale,
    this.platform,
    this.appearances,
  });

  final String size;
  final String idiom;
  final String filename;
  final String scale;
  final String? platform;
  final List<ContentsImageAppearanceObject>? appearances;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'size': size,
      'idiom': idiom,
      'filename': filename,
      'scale': scale,
      if (platform != null) 'platform': platform,
      if (appearances != null)
        'appearances': appearances!.map((e) => e.toJson()).toList(),
    };
  }
}
