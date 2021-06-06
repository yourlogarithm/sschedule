import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sschedule/settings/schedule.dart';
import 'package:sschedule/settings/settings.dart';
import 'package:sschedule/settings/subjectIcons.dart';
import 'package:sschedule/ads.dart';

ValueNotifier<String> confirmedPath = ValueNotifier('images/subjects/flat/Arts.png');

class AddSubject extends StatefulWidget {
  final bool edit;
  final Subject subject;
  const AddSubject({this.edit = false, required this.subject});

  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  TextEditingController nameController = TextEditingController();
  String dropdownValue = 'Science';
  String addedSuccessfully = '';
  Color hintColorName = Color.fromRGBO(94, 94, 94, 1);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.edit){
      nameController.text = widget.subject.name;
      dropdownValue = widget.subject.category;
      confirmedPath.value = widget.subject.imagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 20, 30, MediaQuery.of(context).size.height * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: settingsObject.colorScheme.label,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      'Name',
                      style: TextStyle(
                          color: settingsObject.colorScheme.label,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  )
                ],
              ),
              TextField(
                controller: nameController,
                cursorColor: settingsObject.colorScheme.gradientStart,
                maxLength: 20,
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600
                ),
                decoration: InputDecoration(
                  hintText: 'Enter the subject name...',
                  hintStyle: TextStyle(
                      fontFamily: 'Open Sans', fontWeight: FontWeight.w600,
                      color: hintColorName
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: settingsObject.colorScheme.gradientMedium,
                    width: 2,
                  )),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        color: settingsObject.colorScheme.label,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                          'Category',
                          style: TextStyle(
                              color: settingsObject.colorScheme.label,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color.fromRGBO(94, 94, 94, 1),
                    ),
                    underline: Container(
                      height: 2,
                      color: settingsObject.colorScheme.gradientMedium,
                    ),
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    onChanged: (String? newValue) {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>[
                      'Science',
                      'Creativity',
                      'Language',
                      'Social',
                      'Sport'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.image_outlined,
                        color: settingsObject.colorScheme.label,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                          'Image',
                          style: TextStyle(
                              color: settingsObject.colorScheme.label,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5 - 30,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 246, 246, 1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: settingsObject.colorScheme.gradientStart, width: 3)
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          showDialog(
                              context: context,
                              builder: (_) {
                                return ImagePickDialog();
                              }
                          );
                        },
                        child: ValueListenableBuilder<String>(
                          valueListenable: confirmedPath,
                          builder: (context, value, _) {
                             return Image.asset(value);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.075,
            decoration: BoxDecoration(
                color: settingsObject.colorScheme.gradientStart,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    spreadRadius: 1

                )]
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if(nameController.text.isNotEmpty){
                      interstitialAd();
                      String name = nameController.text;
                      String category = dropdownValue;
                      String imagePath = confirmedPath.value;
                      Subject localSubject = Subject(name: name, category: category, imagePath: imagePath);
                      scheduleObject.addSubject(localSubject);
                      if(widget.edit){
                        scheduleObject.removeSubject(widget.subject);
                      }
                      scheduleObject.bubbleSortSubjects();
                      scheduleObject.writeToFile();
                      setState(() {
                        nameController.text = '';
                        addedSuccessfully = 'Added successfully';
                      });
                    } else {
                      setState(() {
                        hintColorName = Color.fromRGBO(237, 114, 114, 1);
                      });
                    }
                  },
                  child: Center(
                    child: Text(
                      'Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  )
              ),
            ),
          ),
          Container(
            child: Text(
              addedSuccessfully,
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: Color.fromRGBO(122, 179, 116, 1),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ImagePickDialog extends StatefulWidget {
  // const ImagePickDialog({Key key}) : super(key: key);

  @override
  _ImagePickDialogState createState() => _ImagePickDialogState();
}

class _ImagePickDialogState extends State<ImagePickDialog> {
  String localSelectedPath = confirmedPath.value;
  late int selected;

  Widget getImages() {
    List<Widget> output = [];
    for (int i = 0; i < subjectIconsObject.paths.length; i++) {
      BoxDecoration decoration = i == selected ? BoxDecoration(border: Border.all(color: settingsObject.colorScheme.gradientMedium, width: 4)) : BoxDecoration();
      output.add(Container(
          decoration: decoration,
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      selected = i;
                      localSelectedPath = subjectIconsObject.paths[i];
                    });
                  },
                  child: Image.asset(subjectIconsObject.paths[i])
              )
          )
      )
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.8,
      child: GridView.count(
        crossAxisCount: 3,
        children: output,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < subjectIconsObject.paths.length; i++){
      if (subjectIconsObject.paths[i] == localSelectedPath){
        selected = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select an image'),
      content: getImages(),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: settingsObject.colorScheme.gradientMedium))),
        TextButton(
            onPressed: () {
              setState(() {
                confirmedPath.value = localSelectedPath;
              });
              Navigator.pop(context);
            },
            child: Text('Confirm', style: TextStyle(color: settingsObject.colorScheme.gradientMedium)))
      ],
    );
  }
}
