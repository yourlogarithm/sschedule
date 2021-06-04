import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class JSONFile {
  JSONFile(String filename){
    this.fileName = filename;
  }

  late File jsonFile;
  late Directory dir;
  late String fileName;
  bool fileExists = false;
  late Map<dynamic, dynamic> fileContent;
}