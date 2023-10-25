import 'package:flutter/material.dart';
import 'package:kids_game/imagePuzzle/Theme/app_theme.dart';

class CustomeHeadingText extends StatelessWidget {
  const CustomeHeadingText({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Themes.textTheme.displayMedium,
    );
  }
}
