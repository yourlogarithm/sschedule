import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sschedule/content.dart';
import 'package:sschedule/utilities/gradienttext.dart';
import 'package:sschedule/settings/settings.dart';
import 'manageSubjects.dart';
import 'alertDialogs.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.15,
          child: Container(
            decoration: BoxDecoration(gradient: mainGradient()),
          ),
        ),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.15 - 30,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.75 + 70,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 20, 30, MediaQuery.of(context).size.height * 0.1 + 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: settingsObject.colorScheme.label),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return ChangeNameDialog();
                                  });
                            },
                            fillColor: Colors.white,
                            elevation: 3,
                            child: Icon(
                              Icons.edit_outlined,
                              color: settingsObject.colorScheme.label,
                              size: 36.0,
                            ),
                            padding: EdgeInsets.all(24.0),
                            shape: CircleBorder(),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              'Change name',
                              style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19,
                                  color: settingsObject.colorScheme.label),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              showDialog(context: context, builder: (_) {
                                return ChangeAvatar();
                              });
                            },
                            fillColor: Colors.white,
                            elevation: 3,
                            child: Icon(
                              Icons.image_outlined,
                              color: settingsObject.colorScheme.label,
                              size: 36.0,
                            ),
                            padding: EdgeInsets.all(24.0),
                            shape: CircleBorder(),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              'Change avatar',
                              style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19,
                                  color: settingsObject.colorScheme.label),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            content.value = ManageSubjects();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.science_outlined,
                                    color: settingsObject.colorScheme.label),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Manage subjects',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: settingsObject.colorScheme.label,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return ChangeColorSchemeDialog();
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.palette_outlined,
                                    color: settingsObject.colorScheme.label),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Change color scheme',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: settingsObject.colorScheme.label,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            showDialog(context: context, builder: (_) {
                              return ChangeLessonDuration();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.schedule, color: settingsObject.colorScheme.label),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Change lesson duration',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: settingsObject.colorScheme.label,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return ChangeWeekDayStart();
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_today_rounded,
                                    color: settingsObject.colorScheme.label),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Change week start day',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: settingsObject.colorScheme.label,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ))
      ],
    );
  }
}
