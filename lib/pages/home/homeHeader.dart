import 'package:flutter/material.dart';
import 'package:sschedule/utilities/gradienttext.dart';
import 'package:sschedule/settings/settings.dart';
import 'package:intl/intl.dart';
import 'package:sschedule/pages/settingsPage/alertDialogs.dart';

class HomeHeader extends StatelessWidget {
  // const HomeHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        height: MediaQuery.of(context).size.height * 0.27 + 40,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: BoxDecoration(gradient: mainGradient()),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Container(
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: settingsObject.colorScheme.primaryTop,
                                fontFamily: 'Ubuntu',
                                fontSize: 16),
                            children: [
                          TextSpan(
                              text: DateFormat('EEEE ').format(DateTime.now()),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(
                              text: DateFormat('d MMMM').format(DateTime.now()))
                        ])),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 10, 40, 0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          height: 75,
                          margin: EdgeInsets.only(right: 10),
                          child: Center(
                            child: Text(
                              "Hello, ${settingsObject.name}",
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  color: settingsObject.colorScheme.primaryTop,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 34),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 95.0,
                        height: 95.0,
                        decoration: BoxDecoration(
                          color: settingsObject.colorScheme.primaryTop,
                          image: DecorationImage(
                            image: settingsObject.avatar.image,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                            color: settingsObject.colorScheme.gradientEnd,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(40, 10, 40, 0),
                    child: Text(
                      "Feel free to check your schedule...",
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          color: settingsObject.colorScheme.secondaryTop,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
