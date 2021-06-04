import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sschedule/settings/settings.dart';

class GradientText extends StatelessWidget {
  GradientText(
    this.text, {
    required this.gradient,
    required this.style,
  });

  final String text;
  final Gradient gradient;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}

LinearGradient mainGradient({Alignment begin: Alignment.topCenter, Alignment end: Alignment.bottomCenter}) {
  return LinearGradient(colors: settingsObject.colorScheme.gradient, begin: begin, end: end);
}

LinearGradient reverseGradient(LinearGradient gradient) {
  List<Color> colors = gradient.colors;
  return LinearGradient(
      begin: gradient.begin,
      end: gradient.end,
      colors: [colors[1], colors[0]]
  );
}
