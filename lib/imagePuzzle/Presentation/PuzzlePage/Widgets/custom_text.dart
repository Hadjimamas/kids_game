import 'package:flutter/material.dart';
import 'package:kids_game/imagePuzzle/Core/app_theme.dart';

class CustomHeadingText extends StatelessWidget {
  const CustomHeadingText({
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
