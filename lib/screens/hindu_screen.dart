import 'package:cherish/utils/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Hindu extends StatefulWidget {
  const Hindu({super.key});

  @override
  State<Hindu> createState() => _HinduState();
}

class _HinduState extends State<Hindu> {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final themeController = Provider.of<ThemeController>(context);
    final palette = themeController.getPalette(brightness);

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/patience.json',
              width: 200,
              height: 200,
              repeat: true,
              animate: true,
            ),
            Text(
              "Thank you for your patience...",
              style: TextStyle(
                color: palette.text,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Hindu Version will be updated soon!!",
              style: TextStyle(
                color: palette.text,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
