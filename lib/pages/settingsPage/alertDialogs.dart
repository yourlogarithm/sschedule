import 'package:flutter/material.dart';
import 'package:sschedule/settings/settings.dart';
import 'package:sschedule/settings/schedule.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChangeNameDialog extends StatefulWidget {
  // const ChangeNameDialog({Key key}) : super(key: key);

  @override
  _ChangeNameDialogState createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {
  Color hintColorName = Color.fromRGBO(94, 94, 94, 1);
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Change name',
        style: TextStyle(
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w600,
        ),
      ),
      content: TextField(
        controller: controller,
        maxLength: 10,
        decoration: InputDecoration(
            hintText: 'Enter your name...',
            helperText: 'Minimum 2 characters',
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: settingsObject.colorScheme.gradientMedium,
                  width: 2,
                )
            ),
            labelStyle: TextStyle(
                color: settingsObject.colorScheme.gradientStart,
                fontFamily: 'Open Sans'
            ),
            hintStyle: TextStyle(
                color: hintColorName,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600
            )
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
              'Cancel',
              style: TextStyle(color: settingsObject.colorScheme.gradientMedium)
          ),
        ),
        TextButton(
          onPressed: () {
            if (controller.text.length >= 2 && controller.text[0] != ' ' && controller.text[1] != ' ') {
              settingsObject.name = controller.text;
              settingsObject.writeToFile();
              Navigator.pop(context);
            } else {
              setState(() {
                hintColorName = Color.fromRGBO(237, 114, 114, 1);
              });
            }
          },
          child: Text(
              'Confirm',
              style: TextStyle(color: settingsObject.colorScheme.gradientMedium)
          ),
        )
      ],
    );
  }
}

class ChangeColorSchemeDialog extends StatefulWidget {
  // const ChangeColorSchemeDialog({Key key}) : super(key: key);

  @override
  _ChangeColorSchemeDialogState createState() =>
      _ChangeColorSchemeDialogState();
}

class _ChangeColorSchemeDialogState extends State<ChangeColorSchemeDialog> {
  List<bool> boolSelected = [true];
  List<String> listColorSchemes = ['Dark Green'];
  String selected = 'Dark Green';

  List<Widget> getOptions() {
    List<Widget> output = [];
    listColorSchemes.forEach((element) {
      output.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(element),
      ));
    });
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Change color scheme',
        style: TextStyle(
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w600,
        ),
      ),
      content: ToggleButtons(
        borderRadius: BorderRadius.circular(15),
        renderBorder: false,
        fillColor: settingsObject.colorScheme.gradientMedium,
        color: settingsObject.colorScheme.label,
        selectedColor: settingsObject.colorScheme.searchInput,
        splashColor: settingsObject.colorScheme.primaryTop,
        textStyle:
        TextStyle(fontFamily: 'Open Sans', fontWeight: FontWeight.w600),
        isSelected: boolSelected,
        onPressed: (int index) {
          for (int i = 0; i < boolSelected.length; i++) {
            setState(() {
              selected = listColorSchemes[index];
              boolSelected[i] = i == index ? true : false;
            });
          }
        },
        children: getOptions(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
              'Cancel',
              style: TextStyle(color: settingsObject.colorScheme.gradientMedium)
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              switch (selected) {
                case 'Dark Green':
                  settingsObject.setColorScheme('darkGreen');
                  break;
              }
            });
            settingsObject.writeToFile();
            Navigator.pop(context);
          },
          child: Text(
              'Confirm',
              style: TextStyle(color: settingsObject.colorScheme.gradientMedium)
          ),
        )
      ],
    );
  }
}

class ChangeWeekDayStart extends StatefulWidget {
  // const ChangeWeekDayStart({Key key}) : super(key: key);

  @override
  _ChangeWeekDayStartState createState() => _ChangeWeekDayStartState();
}

class _ChangeWeekDayStartState extends State<ChangeWeekDayStart> {
  List<bool> boolSelected = [
    scheduleObject.weekStart == 'Monday' ? true : false,
    scheduleObject.weekStart == 'Sunday' ? true : false
  ];
  List<String> listDays = ['Monday', 'Sunday'];
  String selected = 'Monday';

  List<Widget> getOptions() {
    List<Widget> output = [];
    listDays.forEach((element) {
      output.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(element),
      ));
    });
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Change week start day',
        style: TextStyle(
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w600,
        ),
      ),
      content: ToggleButtons(
        borderRadius: BorderRadius.circular(15),
        renderBorder: false,
        fillColor: settingsObject.colorScheme.gradientMedium,
        color: settingsObject.colorScheme.label,
        selectedColor: settingsObject.colorScheme.searchInput,
        splashColor: settingsObject.colorScheme.primaryTop,
        textStyle:
        TextStyle(fontFamily: 'Open Sans', fontWeight: FontWeight.w600),
        isSelected: boolSelected,
        onPressed: (int index) {
          for (int i = 0; i < boolSelected.length; i++) {
            setState(() {
              selected = listDays[index];
              boolSelected[i] = i == index ? true : false;
            });
          }
        },
        children: getOptions(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
              'Cancel',
              style: TextStyle(color: settingsObject.colorScheme.gradientMedium)),
        ),
        TextButton(
          onPressed: () {
            scheduleObject.weekStart = selected;
            scheduleObject.writeToFile();
            Navigator.pop(context);
          },
          child: Text(
              'Confirm',
              style: TextStyle(color: settingsObject.colorScheme.gradientMedium)),
        )
      ],
    );
  }
}

class ChangeLessonDuration extends StatefulWidget {
  // const ChangeLessonDuration({Key key}) : super(key: key);

  @override
  _ChangeLessonDurationState createState() => _ChangeLessonDurationState();
}

class _ChangeLessonDurationState extends State<ChangeLessonDuration> {
  int lessonDuration = scheduleObject.lessonDuration;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Change week start day',
        style: TextStyle(
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: NumberPicker(
            value: lessonDuration,
            itemCount: 3,
            minValue: 10,
            itemWidth: 70,
            maxValue: 360,
            axis: Axis.horizontal,
            textStyle: TextStyle(
              fontFamily: 'Open Sans',
            ),
            selectedTextStyle: TextStyle(
                color: settingsObject.colorScheme.gradientMedium,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.bold
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black26),
            ),
            onChanged: (value) => setState(() => lessonDuration = value)
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
              'Cancel',
              style: TextStyle(color: settingsObject.colorScheme.gradientMedium)
          ),
        ),
        TextButton(
          onPressed: () {
            scheduleObject.lessonDuration = lessonDuration;
            scheduleObject.writeToFile();
            scheduleObject.init().then((_){
              scheduleObject.setWeekDays();
              Navigator.pop(context);
            });
          },
          child: Text(
              'Confirm',
              style: TextStyle(color: settingsObject.colorScheme.gradientMedium)
          ),
        )
      ],
    );
  }
}

class ChangeAvatar extends StatefulWidget {
  // const ChangeAvatar({Key key}) : super(key: key);

  @override
  _ChangeAvatarState createState() => _ChangeAvatarState();
}

class _ChangeAvatarState extends State<ChangeAvatar> {
  late File _image;
  List<bool> chosen = [false, false];

  Future loadImage() async {
    var file = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(file!.path);
      chosen[0] = true;
      chosen[1] = false;
    });
  }

  Future shootImage() async {
    var file = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _image = File(file!.path);
      chosen[0] = false;
      chosen[1] = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Change avatar',
        style: TextStyle(
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: settingsObject.colorScheme.secondaryTop,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: loadImage,
                    child: !chosen[0] ? Icon(Icons.image, color: settingsObject.colorScheme.searchInput, size: 32) :
                    Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: Image.file(_image).image,
                              fit: BoxFit.cover
                          ),
                        )
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: settingsObject.colorScheme.searchInput,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: shootImage,
                    child: !chosen[1] ? Icon(Icons.photo_camera, color: settingsObject.colorScheme.secondaryTop, size: 32) :
                    Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: Image.file(_image).image,
                              fit: BoxFit.cover
                          ),
                        )
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
              'Cancel',
              style: TextStyle(color: settingsObject.colorScheme.gradientMedium)
          ),
        ),
        TextButton(
          onPressed: () {
            settingsObject.changeImage(_image);
            settingsObject.writeToFile();
            Navigator.pop(context);
          },
          child: Text(
              'Confirm',
              style: TextStyle(color: settingsObject.colorScheme.gradientMedium)
          ),
        )
      ],
    );
  }
}
