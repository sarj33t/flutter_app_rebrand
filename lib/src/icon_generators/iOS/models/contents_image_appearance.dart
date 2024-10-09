///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/24
/// @Message :
/// [ContentsImageAppearanceObject]
class ContentsImageAppearanceObject {
  ContentsImageAppearanceObject({
    required this.appearance,
    required this.value,
  });

  final String appearance;
  final String value;

  Map<String, String> toJson() {
    return <String, String>{
      'appearance': appearance,
      'value': value,
    };
  }
}