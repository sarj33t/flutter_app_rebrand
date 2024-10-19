import 'dart:io';
import 'dart:convert';
import 'package:flutter_app_rebrand/src/constants/ansi_constants.dart';
import 'package:flutter_app_rebrand/src/constants/far_constants.dart';

void main() {
  const String green = '\x1B[32m';  // ANSI code for green
  const String reset = '\x1B[0m';    // ANSI code to reset color

  // Create a JsonEncoder with an indentation of 2 spaces
  final JsonEncoder encoder = JsonEncoder.withIndent('  ');

  // Convert the map to pretty-printed JSON
  final String jsonString = encoder.convert(FARConstants.defaultConfig);

  // Write the JSON to a file
  final File file = File('rebrand_config.json');
  file.writeAsStringSync(jsonString);
  print('${green}${checkMark} File rebrand.json has been created or updated successfully ${checkMark}$reset');
  print('${magenta}NOTE: Please make sure to update this file.$reset');
}
