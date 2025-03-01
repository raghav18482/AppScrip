import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Future<String> sqlitePath() async {
  if (Platform.isAndroid) {
    return getDatabasesPath();
  } else if (Platform.isIOS) {
    final directory = await getLibraryDirectory();
    return directory.path;
  } else {
    throw StateError('Unsupported platform');
  }
}