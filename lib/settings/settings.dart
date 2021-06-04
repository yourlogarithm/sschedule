import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'jsonFile.dart';
import 'package:flutter/material.dart';

SettingsManager settingsObject = SettingsManager('settings.json');

class SettingsManager extends JSONFile {
  SettingsManager(filename) : super(filename);
  late String name;
  late bool isDefaultImg;
  late Image avatar;
  late String stringColorScheme;
  late File imageFile;
  late ColorScheme colorScheme;

  void setColorScheme(String arg){
    colorScheme = ColorScheme(arg);
  }

  init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    dir = directory;
    jsonFile = File(dir.path + '/' + fileName);
    fileExists = await jsonFile.exists();
    if (fileExists) {
      String data = await jsonFile.readAsString();
      fileContent = jsonDecode(data);
      name = fileContent['name'];
      isDefaultImg = fileContent['isDefaultImg'];
      if (isDefaultImg){
        avatar = Image.asset('images/profile.jpg');
      } else {
        imageFile = File(fileContent['avatar']);
        avatar = Image.file(imageFile);
      }
      stringColorScheme = fileContent['colorScheme'];
    } else {
      createFile();
    }
  }

  void changeImage(File arg) {
    isDefaultImg = false;
    imageFile = arg;
    avatar = Image.file(arg);
  }

  void createFile(){
    File file = File(dir.path + '/' + fileName);
    name = 'yourname';
    stringColorScheme = 'darkGreen';
    isDefaultImg = true;
    avatar = Image.asset('images/profile.jpg');
    fileContent = {'name': 'yourname', 'colorScheme': 'darkGreen', 'isDefault': true, 'avatar': 'images/profile.jpg'};
    file.create().then((_) {
      fileExists = true;
      file.writeAsString(jsonEncode(fileContent));
    });
  }

  void writeToFile(){
    fileContent['name'] = name;
    fileContent['colorScheme'] = stringColorScheme;
    fileContent['isDefaultImg'] = isDefaultImg;
    if (isDefaultImg){
      fileContent['avatar'] = 'images/profile.png';
    } else {
      print(imageFile.path);
      fileContent['avatar'] = imageFile.path;
    }
    jsonFile.writeAsString(jsonEncode(fileContent));
  }
}

class ColorScheme {
  late Color gradientMedium;
  late Color gradientStart;
  late Color gradientEnd;
  late List<Color> gradient;
  late Color primaryTop;
  late Color secondaryTop;
  late Color label;
  late Color href;
  late Color primaryText;
  late Color secondaryText;
  late Color tertiaryText;
  late Color searchInput;
  late Color filterSelector;
  late Color className;

  ColorScheme(String colorScheme) {
    switch (colorScheme) {
      case 'darkGreen':
        gradientStart = Color.fromRGBO(104, 162, 133, 1);
        gradientEnd = Color.fromRGBO(86, 119, 108, 1);
        gradientMedium = Color.fromRGBO(97, 145, 123, 1);
        gradient = [gradientStart, gradientEnd];
        primaryTop = Color.fromRGBO(204, 223, 204, 1);
        secondaryTop = Color.fromRGBO(170, 205, 189, 1);
        label = Color.fromRGBO(76, 76, 76, 1);
        href = Color.fromRGBO(126, 141, 125, 1);
        primaryText = Color.fromRGBO(101, 133, 98, 1);
        secondaryText = Color.fromRGBO(88, 95, 88, 1);
        tertiaryText = Color.fromRGBO(105, 111, 104, 1.0);
        searchInput = Color.fromRGBO(228, 245, 237, 1);
        className = Color.fromRGBO(166, 177, 165, 1);
        filterSelector = Color.fromRGBO(113, 142, 145, 1);
        break;
    }
  }
}