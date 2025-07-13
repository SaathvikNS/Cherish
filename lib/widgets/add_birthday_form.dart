import 'package:cherish/db/birthday_database.dart';
import 'package:cherish/models/birthday.dart';
import 'package:cherish/utils/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class AddBirthdayForm extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback? onBirthdayAdded;

  const AddBirthdayForm({
    super.key,
    required this.scrollController,
    this.onBirthdayAdded,
  });

  @override
  State<AddBirthdayForm> createState() => _AddBirthdayFormState();
}

enum InputMode { year, age }

class _AddBirthdayFormState extends State<AddBirthdayForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController customRelationController =
      TextEditingController();
  final TextEditingController customDayController = TextEditingController();
  final TextEditingController customHourController = TextEditingController();
  final TextEditingController customMinutesController = TextEditingController();
  final TextEditingController ageYearController = TextEditingController();

  int? selectedDay;
  int? selectedMonth;
  int? year;
  int? age;
  String? selectedRemindBefore = "At 12 AM";
  int? remindBeforeMinutes;
  String? selectedRelation;

  InputMode selectedMode = InputMode.year;

  final List<String> commonRelations = [
    "Friend",
    "Family",
    "Colleague",
    "Partner",
    "Other",
  ];

  final List<String> reminderOptions = [
    "At 12 AM",
    "5 minutes before",
    "1 hour before",
    "1 day before",
    "Custom",
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final themeController = Provider.of<ThemeController>(context);
    final palette = themeController.getPalette(brightness);

    void showCustomToast(BuildContext context, String message) {
      final overlay = Overlay.of(context);
      final overlayEntry = OverlayEntry(
        builder: (ctx) => Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Center(
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: palette.secondaryBackground,
                ),
                child: Text(
                  message,
                  style: TextStyle(color: palette.text),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );

      overlay.insert(overlayEntry);
      Future.delayed(Duration(seconds: 5)).then((_) => overlayEntry.remove());
    }

    String capitalize(String name) {
      return name
          .split(' ')
          .map(
            (e) => e.isNotEmpty ? '${e[0].toUpperCase()}${e.substring(1)}' : '',
          )
          .join(' ');
    }

    int daysInMonth(int month, int year) {
      if (month == 2) {
        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
          return 29;
        } else {
          return 28;
        }
      }

      if ([4, 6, 9, 11].contains(month)) return 30;

      return 31;
    }

    String monthName(int month) {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return months[month - 1];
    }

    return Container(
      decoration: BoxDecoration(
        color: palette.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Divider(
              thickness: 3,
              color: palette.divider,
              indent: MediaQuery.of(context).size.width * (4 / 11),
              endIndent: MediaQuery.of(context).size.width * (4 / 11),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Add Birthday",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: palette.accentColor,
                ),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  controller: widget.scrollController,
                  children: [
                    // Name
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Full Name *",
                        labelStyle: TextStyle(color: palette.secondaryText),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: palette.secondaryText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: palette.secondaryText,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor: Colors.blue[300],
                      style: TextStyle(color: palette.text),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? "Please Enter Full Name"
                          : null,
                    ),
                    SizedBox(height: 15),
                    // Date and month
                    Row(
                      spacing: 20,
                      children: [
                        // Date
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: selectedDay,
                            hint: const Text("Day *"),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: palette.secondaryText,
                              ),
                              focusColor: Colors.red,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: palette.accentColor,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: palette.secondaryText,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: palette.secondaryText,
                                  width: 2,
                                ),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                              ),
                            ),
                            dropdownColor: palette.secondaryBackground,
                            items:
                                (selectedMonth != null
                                        ? List.generate(
                                            daysInMonth(
                                              selectedMonth!,
                                              year ?? DateTime.now().year,
                                            ),
                                            (i) => i + 1,
                                          )
                                        : List.generate(31, (i) => i + 1))
                                    .map(
                                      (day) => DropdownMenuItem(
                                        value: day,
                                        child: Text(day.toString()),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDay = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? "Required" : null,
                          ),
                        ),
                        // Month
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: selectedMonth,
                            hint: const Text("Month *"),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: palette.secondaryText,
                              ),
                              focusColor: Colors.red,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: palette.accentColor,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: palette.secondaryText,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: palette.secondaryText,
                                  width: 2,
                                ),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                              ),
                            ),
                            dropdownColor: palette.secondaryBackground,
                            items: List.generate(12, (i) => i + 1)
                                .map(
                                  (month) => DropdownMenuItem(
                                    value: month,
                                    child: Text(monthName(month)),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMonth = value;
                                final maxDay = daysInMonth(
                                  selectedMonth!,
                                  year ?? DateTime.now().year,
                                );
                                if (selectedDay != null &&
                                    selectedDay! > maxDay) {
                                  selectedDay = null;
                                  showCustomToast(
                                    context,
                                    "Day Reset: ${monthName(selectedMonth!)} has only $maxDay days",
                                  );
                                }
                              });
                            },

                            validator: (value) =>
                                value == null ? "Required" : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    // Year and Age
                    Row(
                      spacing: 20,
                      children: [
                        // Dropdown
                        Expanded(
                          child: DropdownButtonFormField<InputMode>(
                            value: selectedMode,
                            hint: const Text("Type"),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: palette.secondaryText,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            dropdownColor: palette.secondaryBackground,
                            items: [
                              DropdownMenuItem(
                                value: InputMode.year,
                                child: Text('Year'),
                              ),
                              DropdownMenuItem(
                                value: InputMode.age,
                                child: Text('Age'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedMode = value!;
                                ageYearController.clear();
                                age = null;
                                year = null;
                              });
                            },
                          ),
                        ),
                        // Text Field
                        Expanded(
                          child: TextFormField(
                            controller: ageYearController,
                            decoration: InputDecoration(
                              labelText: selectedMode == InputMode.year
                                  ? "Year"
                                  : "Age",
                              labelStyle: TextStyle(
                                color: palette.secondaryText,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: palette.secondaryText,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: palette.secondaryText,
                                  width: 2,
                                ),
                              ),
                            ),
                            cursorColor: Colors.blue[300],
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final parsed = int.tryParse(value);
                              setState(() {
                                if (selectedMode == InputMode.year) {
                                  year = parsed;
                                  age = (year != null)
                                      ? DateTime.now().year - year!
                                      : null;
                                  final maxDays = daysInMonth(
                                    selectedMonth ?? DateTime.now().month,
                                    parsed ?? DateTime.now().year,
                                  );
                                  if (selectedMonth != null &&
                                      selectedDay != null &&
                                      selectedDay! > maxDays) {
                                    selectedDay = null;
                                    showCustomToast(
                                      context,
                                      "Day Reset: ${monthName(selectedMonth!)} has only $maxDays days",
                                    );
                                  }
                                } else {
                                  age = parsed;
                                  final currentYear = DateTime.now().year;
                                  int newYear = currentYear - (age ?? 0);
                                  year = newYear;
                                  final maxDays = daysInMonth(
                                    selectedMonth ?? DateTime.now().month,
                                    newYear,
                                  );
                                  if (selectedMonth != null &&
                                      selectedDay != null &&
                                      selectedDay! > maxDays) {
                                    selectedDay = null;
                                    showCustomToast(
                                      context,
                                      "Day Reset: ${monthName(selectedMonth!)} has only $maxDays days",
                                    );
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    // Relation
                    DropdownButtonFormField<String>(
                      value: selectedRelation,
                      hint: const Text("Relation"),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: palette.secondaryText),
                        focusColor: Colors.red,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: palette.accentColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: palette.secondaryText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: palette.secondaryText,
                            width: 2,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      dropdownColor: palette.secondaryBackground,
                      items: commonRelations
                          .map(
                            (relation) => DropdownMenuItem(
                              value: relation,
                              child: Text(relation),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRelation = value;
                          if (value != "Other") {
                            customRelationController.clear();
                          }
                        });
                      },
                    ),

                    if (selectedRelation == "Other") SizedBox(height: 15),
                    if (selectedRelation == "Other")
                      TextFormField(
                        controller: customRelationController,
                        decoration: InputDecoration(
                          labelText: "Enter Relation",
                          labelStyle: TextStyle(color: palette.secondaryText),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: palette.secondaryText,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: palette.secondaryText,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 15),
                    // Reference
                    TextFormField(
                      controller: referenceController,
                      decoration: InputDecoration(
                        labelText: "Reference",
                        labelStyle: TextStyle(color: palette.secondaryText),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: palette.secondaryText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: palette.secondaryText,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor: Colors.blue[300],
                      style: TextStyle(color: palette.text),
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: 15),
                    // Whatsapp Number
                    TextFormField(
                      controller: whatsappController,
                      decoration: InputDecoration(
                        labelText: "Whatsapp Number",
                        labelStyle: TextStyle(color: palette.secondaryText),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: palette.secondaryText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: palette.secondaryText,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor: Colors.blue[300],
                      style: TextStyle(color: palette.text),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return "Only numbers allowed";
                          }
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: palette.secondaryText),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: palette.secondaryText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: palette.secondaryText,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor: Colors.blue[300],
                      style: TextStyle(color: palette.text),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return "Enter a valid email";
                          }
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    // Instagram
                    TextFormField(
                      controller: instagramController,
                      decoration: InputDecoration(
                        labelText: "Instagram ID",
                        labelStyle: TextStyle(color: palette.secondaryText),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: palette.secondaryText),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: palette.secondaryText,
                            width: 2,
                          ),
                        ),
                      ),
                      cursorColor: Colors.blue[300],
                      style: TextStyle(color: palette.text),
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: 15),
                    // Reminder
                    DropdownButtonFormField<String>(
                      value: selectedRemindBefore,
                      dropdownColor: palette.secondaryBackground,
                      items: reminderOptions
                          .map(
                            (option) => DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedRemindBefore = val;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Remind Before",
                        labelStyle: TextStyle(color: palette.secondaryText),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: palette.secondaryText),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    if (selectedRemindBefore == "Custom")
                      Row(
                        spacing: 20,
                        children: [
                          // remind days
                          Expanded(
                            child: TextFormField(
                              controller: customDayController,
                              decoration: InputDecoration(
                                labelText: "Days",
                                labelStyle: TextStyle(
                                  color: palette.secondaryText,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: palette.secondaryText,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: palette.secondaryText,
                                    width: 2,
                                  ),
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              cursorColor: Colors.blue[300],
                              style: TextStyle(color: palette.text),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          // remind minutes
                          Expanded(
                            child: TextFormField(
                              controller: customHourController,
                              decoration: InputDecoration(
                                labelText: "Hours",
                                labelStyle: TextStyle(
                                  color: palette.secondaryText,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: palette.secondaryText,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: palette.secondaryText,
                                    width: 2,
                                  ),
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              cursorColor: Colors.blue[300],
                              style: TextStyle(color: palette.text),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          // remind seconds
                          Expanded(
                            child: TextFormField(
                              controller: customMinutesController,
                              decoration: InputDecoration(
                                labelText: "Minutes",
                                labelStyle: TextStyle(
                                  color: palette.secondaryText,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: palette.secondaryText,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: palette.secondaryText,
                                    width: 2,
                                  ),
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              cursorColor: Colors.blue[300],
                              style: TextStyle(color: palette.text),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            // Buttons
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 15,
                right: 15,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: palette.accentColor,
                    ),
                    child: Text("Cancel"),
                  ),
                  // Add
                  ElevatedButton(
                    onPressed: () async {
                      switch (selectedRemindBefore) {
                        case "5 minutes before":
                          remindBeforeMinutes = 5;
                          break;
                        case "1 hour before":
                          remindBeforeMinutes = 60;
                          break;
                        case "1 day before":
                          remindBeforeMinutes = 24 * 60;
                          break;
                        case "Custom":
                          final days =
                              int.tryParse(customDayController.text.trim()) ??
                              0;
                          final hours =
                              int.tryParse(customHourController.text.trim()) ??
                              0;
                          final minutes =
                              int.tryParse(
                                customMinutesController.text.trim(),
                              ) ??
                              0;
                          remindBeforeMinutes =
                              days * 24 * 60 + hours * 60 + minutes;
                          break;
                        default:
                          remindBeforeMinutes = 0;
                      }

                      if (_formKey.currentState!.validate()) {
                        final newBirthday = Birthday(
                          name: capitalize(nameController.text.trim()),
                          day: selectedDay!,
                          month: selectedMonth!,
                          year: year,
                          age: age,
                          relation: selectedRelation == "Other"
                              ? (customRelationController.text.trim().isEmpty
                                    ? null
                                    : capitalize(
                                        customRelationController.text.trim(),
                                      ))
                              : selectedRelation,
                          reference: referenceController.text.trim().isEmpty
                              ? null
                              : capitalize(referenceController.text.trim()),
                          whatsapp: whatsappController.text.trim().isEmpty
                              ? null
                              : whatsappController.text.trim(),
                          email: emailController.text.trim().isEmpty
                              ? null
                              : emailController.text.trim().toLowerCase(),
                          instagram: instagramController.text.trim().isEmpty
                              ? null
                              : instagramController.text.trim(),
                          remindBefore: Duration(minutes: remindBeforeMinutes!),
                        );

                        await BirthdayDatabase.instance.insertBirthday(
                          newBirthday,
                        );

                        widget.onBirthdayAdded?.call();

                        if (!context.mounted) return;

                        showCustomToast(
                          context,
                          "New Birthday added to Cherish",
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: palette.accentColor,
                      foregroundColor: palette.backgroundColor,
                    ),
                    child: Text(
                      "Add",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
