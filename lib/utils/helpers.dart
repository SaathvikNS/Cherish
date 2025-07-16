import 'package:cherish/db/birthday_database.dart';
import 'package:cherish/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:cherish/models/birthday.dart';

Future<void> confirmAndDelete({
  required BuildContext context,
  required Birthday birthday,
  required ThemePalette palette,
  required VoidCallback onBirthdayDelete,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: palette.secondaryBackground,
      title: Text('Delete Birthday'),
      content: Text(
        "Are you sure you want to delete ${birthday.name}'s birthday?",
        style: TextStyle(color: palette.text),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("Cancel", style: TextStyle(color: palette.text)),
        ),
        SizedBox(
          height: 35,
          width: 80,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete", style: TextStyle(color: palette.text)),
          ),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    await BirthdayDatabase.instance.deleteBirthday(birthday.id!);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${birthday.name}'s birthday deleted.")),
      );
    }
    onBirthdayDelete.call();
  }
}
