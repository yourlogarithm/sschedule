import 'package:flutter/services.dart';
import 'dart:convert';

SubjectIcons subjectIconsObject = SubjectIcons();

class SubjectIcons {
  late List<dynamic> paths;

  Future<List> getPaths() async {
    String fileToString = await rootBundle.loadString('images/AssetManifest.json');
    List decoded = jsonDecode(fileToString);
    return decoded;
  }

}