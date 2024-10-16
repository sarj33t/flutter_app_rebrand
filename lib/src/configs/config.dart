///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/24
/// @Message :
/// [Config]
class Config {
  final String iconPath;
  final bool removeAlphaIOS;
  final String backgroundColorIOS;

  Config(
      {required this.iconPath,
      this.removeAlphaIOS = true,
      this.backgroundColorIOS = '#FFFFFF'});
}
