///
/// @AUTHOR : Sarjeet Sandhu
/// @DATE : 09/10/24
/// @Message :
/// [ContentsInfoObject]
class ContentsInfoObject {
  ContentsInfoObject({required this.version, required this.author});
  final int version;
  final String author;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'version': version,
      'author': author,
    };
  }
}