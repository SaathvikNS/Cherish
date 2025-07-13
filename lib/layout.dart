import 'package:cherish/screens/hindu_screen.dart';
import 'package:cherish/screens/western_screen.dart';
import 'package:cherish/utils/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [Gregorian(), Hindu()];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final themeController = Provider.of<ThemeController>(context);
    final palette = themeController.getPalette(brightness);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.backgroundColor,
        title: Text(
          "Cherish",
          style: TextStyle(
            color: palette.accentColor,
            fontFamily: 'Akaya',
            fontSize: 30,
          ),
        ),
        iconTheme: IconThemeData(color: palette.accentColor),
      ),
      drawer: Drawer(
        backgroundColor: palette.backgroundColor,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 100,
              width: double.infinity,
              child: Center(
                child: Text(
                  // Use akaya font
                  "CHERISH",
                  style: TextStyle(
                    fontSize: 40,
                    color: palette.accentColor,
                    fontFamily: 'ShellinaSnow',
                  ),
                ),
              ),
            ),

            Divider(
              thickness: 2,
              color: palette.divider,
              endIndent: 15,
              indent: 15,
            ),

            ListTile(
              leading: Icon(
                Icons.calendar_month,
                color: palette.accentColor,
                size: 25,
              ),
              title: Text(
                "Gregorian",
                style: TextStyle(color: palette.accentColor, fontSize: 16),
              ),
              horizontalTitleGap: 20,
              onTap: () {
                themeController.switchAppMode(AppMode.western);
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(
                Icons.temple_hindu,
                color: palette.accentColor,
                size: 25,
              ),
              title: Text(
                "Hindu",
                style: TextStyle(color: palette.accentColor, fontSize: 16),
              ),
              horizontalTitleGap: 20,
              onTap: () {
                themeController.switchAppMode(AppMode.hindu);
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),

            // const Spacer(),
            ListTile(
              leading: ClipRect(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: AnimatedSlide(
                    offset: Theme.of(context).brightness == Brightness.dark
                        ? const Offset(0, -1)
                        : Offset.zero,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.light_mode,
                          size: 25,
                          color: palette.accentColor,
                        ),
                        Icon(
                          Icons.dark_mode,
                          size: 25,
                          color: palette.accentColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: Text(
                "Switch Theme",
                style: TextStyle(color: palette.accentColor, fontSize: 16),
              ),
              horizontalTitleGap: 20,
              onTap: () => themeController.switchThemeMode(),
            ),
          ],
        ),
      ),
      body: Container(
        color: palette.backgroundColor,
        child: Column(
          children: [
            Divider(
              thickness: 2,
              color: palette.divider,
              height: 2,
              indent: 15,
              endIndent: 15,
            ),
            Expanded(child: _screens[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}
