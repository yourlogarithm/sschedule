import 'package:flutter/material.dart';
import 'settings/settings.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'settings/schedule.dart';

class WelcomePage extends StatefulWidget {
  // const WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int lessonDuration = 45;
  List<bool> boolDay = [true, false];
  List<String> listStartDay = ['Monday', 'Sunday'];
  List<bool> boolColorscheme = [true];
  List<String> listColorschemes = ['darkGreen'];
  Color selectedBackroundColor = Color.fromRGBO(97, 145, 123, 0.9);
  Color selectedTextColor = Color.fromRGBO(228, 245, 237, 1);
  Color unselectedTextColor = Color.fromRGBO(76, 76, 76, 1);

  TextEditingController nameController = TextEditingController();
  Color colorNameHint = Color.fromRGBO(115, 115, 115, 1);

  Map<String, dynamic> selectedValues = {
    'weekStart': 'Monday',
    'colorScheme': 'darkGreen'
  };

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    if (boolColorscheme[0]){
      setState(() {
        selectedBackroundColor = Color.fromRGBO(97, 145, 123, 0.9);
        selectedTextColor = Color.fromRGBO(228, 245, 237, 1);
        unselectedTextColor = Color.fromRGBO(76, 76, 76, 1);
      });
    }
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Center(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: Text(
                      'Welcome!',
                      style: TextStyle(
                          color: selectedBackroundColor,
                          fontFamily: 'Ubuntu',
                          fontSize: 32
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'What is your name?',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TextField(
                          controller: nameController,
                          maxLength: 10,
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                          ),
                          cursorColor: selectedBackroundColor,
                          decoration: InputDecoration(
                            hintText: 'Enter your name...',
                            hintStyle: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                              color: colorNameHint
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: selectedBackroundColor,
                                  width: 2,
                                )
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'What is your usual class length? (minutes)',
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: NumberPicker(
                          value: lessonDuration,
                          minValue: 10,
                          maxValue: 360,
                          axis: Axis.horizontal,
                          textStyle: TextStyle(
                              fontFamily: 'Open Sans',
                          ),
                          selectedTextStyle: TextStyle(
                            color: selectedBackroundColor,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black26),
                          ),
                          onChanged: (value) => setState(() => lessonDuration = value
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Select when does the week starts for you: ',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: ToggleButtons(
                          renderBorder: false,
                          isSelected: boolDay,
                          borderRadius: BorderRadius.circular(15),
                          fillColor: selectedBackroundColor,
                          color: unselectedTextColor,
                          selectedColor: selectedTextColor,
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0; i < 2; i++){
                                selectedValues['weekStart'] = listStartDay[index];
                                boolDay[i] = i == index ? true : false;
                              }
                            });
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                'Monday',
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                  'Sunday',
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Select the preferred color scheme:',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: ToggleButtons(
                          borderRadius: BorderRadius.circular(15),
                          renderBorder: false,
                          isSelected: boolColorscheme,
                          fillColor: selectedBackroundColor,
                          color: unselectedTextColor,
                          selectedColor: selectedTextColor,
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0; i < boolColorscheme.length; i++){
                                selectedValues['colorScheme'] = listColorschemes[index];
                                boolColorscheme[i] = i == index ? true : false;
                              }
                            });
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: Text('Dark Green'),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty){
                        settingsObject.name = nameController.text;
                        settingsObject.stringColorScheme = selectedValues['colorScheme'];
                        settingsObject.writeToFile();
                        scheduleObject.weekStart = selectedValues['weekStart'];
                        scheduleObject.lessonDuration = lessonDuration;
                        scheduleObject.writeToFile();
                        Navigator.pushReplacementNamed(context, '/content');
                      } else {
                        setState(() {
                          colorNameHint = Color.fromRGBO(237, 114, 114, 1);
                        });
                      }
                    },
                    backgroundColor: selectedBackroundColor,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: selectedTextColor,
                      size: 24.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
