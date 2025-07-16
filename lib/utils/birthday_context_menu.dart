import 'package:cherish/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cherish/models/birthday.dart';

Future<void> showBirthdayContextMenu({
  required BuildContext context,
  required Offset positoin,
  required Birthday birthday,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
  required ThemePalette palette,
}) async {
  HapticFeedback.mediumImpact();

  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  await showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromLTRB(positoin.dx, positoin.dy, 0, 0),
      Offset.zero & overlay.size,
    ),
    color: palette.secondaryBackground,
    items: [
      PopupMenuItem(
        child: ListTile(
          dense: true,
          leading: Icon(Icons.edit),
          title: Text("Edit"),
          onTap: () {
            Navigator.pop(context);
            onEdit();
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          dense: true,
          leading: Icon(Icons.delete),
          title: Text("Delete"),
          onTap: () {
            Navigator.pop(context);
            onDelete();
          },
        ),
      ),
      if (birthday.whatsapp != null && birthday.whatsapp!.trim().isNotEmpty)
        PopupMenuItem(
          child: ListTile(
            dense: true,
            leading: Icon(Icons.chat),
            title: Text('Whatsapp'),
            onTap: () {
              Navigator.pop(context);
              final url =
                  'https://wa.me/+91${birthday.whatsapp!}?text=Many more Happy Returns of the day ${birthday.name.split(" ")[0]}';
              launchUrl(Uri.parse(url));
            },
          ),
        ),
      if (birthday.email != null && birthday.email!.trim().isNotEmpty)
        PopupMenuItem(
          child: ListTile(
            dense: true,
            leading: Icon(Icons.email),
            title: Text("Email"),
            onTap: () {
              Navigator.pop(context);
              final uri = Uri(
                scheme: 'mailto',
                path: birthday.email!,
                query:
                    "subject=Birthday Wishes&body=Many more happy returns of the day ${birthday.name.split(' ')[0]}",
              );
              launchUrl(uri);
            },
          ),
        ),
      if (birthday.instagram != null && birthday.instagram!.trim().isNotEmpty)
        PopupMenuItem(
          child: ListTile(
            dense: true,
            leading: Icon(Icons.camera_alt),
            title: Text("Instagram"),
            onTap: () {
              Navigator.pop(context);
              final url = 'https://instagram.com/${birthday.instagram!}';
              launchUrl(Uri.parse(url));
            },
          ),
        ),
    ],
  );
}
