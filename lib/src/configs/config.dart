///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/24
/// @Message :
/// [Config]
class Config{
  final String imagePath;
  final bool removeAlphaIOS;
  final String backgroundColorIOS;

  Config({required this.imagePath, this.removeAlphaIOS = true, this.backgroundColorIOS = '#FFFFFF'});
}