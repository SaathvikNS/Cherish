import 'package:cherish/models/birthday.dart';
import 'package:cherish/utils/birthday_context_menu.dart';
import 'package:cherish/utils/helpers.dart';
import 'package:cherish/utils/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cherish/widgets/add_birthday_form.dart';
import 'package:cherish/db/birthday_database.dart';
import 'package:lottie/lottie.dart';

class Gregorian extends StatefulWidget {
  const Gregorian({super.key});

  @override
  State<Gregorian> createState() => _GregorianState();
}

class _GregorianState extends State<Gregorian> {
  List<_GroupedItem> displayItems = [];

  Future<void> fetchAndGroupBirthdays() async {
    final dbBirthdays = await BirthdayDatabase.instance.fetchAllBirthdays();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    final List<Birthday> todayList = [];
    final List<Birthday> tomorrowList = [];
    final List<Birthday> laterThisMonth = [];
    final List<Birthday> allFutureBirthdays = List.from(dbBirthdays);

    allFutureBirthdays.sort(
      (a, b) => _nextBirthday(a).compareTo(_nextBirthday(b)),
    );

    final List<_GroupedItem> updatedDisplayItems = [];

    for (final b in allFutureBirthdays) {
      final birthday = DateTime(now.year, b.month, b.day);
      if (_isSameDay(birthday, today)) {
        todayList.add(b);
      } else if (_isSameDay(birthday, tomorrow)) {
        tomorrowList.add(b);
      } else if (b.month == now.month && birthday.isAfter(tomorrow)) {
        laterThisMonth.add(b);
      }
    }

    final Set<Birthday> special = {
      ...todayList,
      ...tomorrowList,
      ...laterThisMonth,
    };

    if (todayList.isNotEmpty) {
      updatedDisplayItems.add(_GroupedItem.header("Today"));
      _addSorted(updatedDisplayItems, todayList);
    }

    if (tomorrowList.isNotEmpty) {
      updatedDisplayItems.add(_GroupedItem.header("Tomorrow"));
      _addSorted(updatedDisplayItems, tomorrowList);
    }

    if (laterThisMonth.isNotEmpty) {
      updatedDisplayItems.add(_GroupedItem.header("Later in This Month"));
      _addSorted(updatedDisplayItems, laterThisMonth);
    }

    DateTime? lastHeaderDate;
    for (final b in allFutureBirthdays) {
      if (special.contains(b)) continue;

      final nextDate = _nextBirthday(b);
      if (lastHeaderDate == null ||
          nextDate.year != lastHeaderDate.year ||
          nextDate.month != lastHeaderDate.month) {
        final label = (nextDate.year != now.year)
            ? "${DateFormat.MMMM().format(nextDate)} ${nextDate.year}"
            : DateFormat.MMMM().format(nextDate);
        updatedDisplayItems.add(_GroupedItem.header(label));
        lastHeaderDate = nextDate;
      }

      updatedDisplayItems.add(_GroupedItem.birthday(b));
    }

    setState(() {
      displayItems = updatedDisplayItems;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAndGroupBirthdays();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final themeController = Provider.of<ThemeController>(context);
    final palette = themeController.getPalette(brightness);

    final now = DateTime.now();

    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec",
    ];

    String getInitials(String name) {
      final clean = name
          .trim()
          .split(RegExp(r'\s+'))
          .where((word) => word.isNotEmpty)
          .map((word) => word[0].toUpperCase())
          .join();
      return clean.substring(0, clean.length >= 2 ? 2 : 1);
    }

    return Scaffold(
      body: displayItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/empty.json',
                    width: 200,
                    height: 200,
                    repeat: true,
                    animate: true,
                  ),
                  Text(
                    "Nothing to Display here",
                    style: TextStyle(
                      color: palette.text,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Click on '+' to add new birthdays",
                    style: TextStyle(
                      color: palette.text,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 100),
                ],
              ),
            )
          : ListView.builder(
              itemCount: displayItems.length,
              itemBuilder: (context, index) {
                final item = displayItems[index];
                if (item.isHeader) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        item.header!,
                        style: TextStyle(
                          fontSize: 16,
                          color: palette.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else {
                  final b = item.birthday!;
                  final formatted = "${b.day} ${months[b.month - 1]} ${b.year}";
                  final age = b.calculatedAge;

                  return GestureDetector(
                    onLongPressStart: (details) {
                      showBirthdayContextMenu(
                        context: context,
                        positoin: details.globalPosition,
                        birthday: b,
                        palette: palette,
                        onEdit: () {
                          _openEditBirthdaySheet(context, b);
                        },
                        onDelete: () {
                          confirmAndDelete(
                            context: context,
                            birthday: b,
                            palette: palette,
                            onBirthdayDelete: fetchAndGroupBirthdays,
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListTile(
                        leading: LayoutBuilder(
                          builder: (context, constraints) {
                            double size = constraints.maxHeight * 0.85;
                            return Container(
                              height: size,
                              width: size,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size / 2),
                                border: Border.all(color: palette.divider),
                              ),
                              child: Center(
                                child: Text(
                                  getInitials(b.name),
                                  style: TextStyle(
                                    color: palette.accentColor,
                                    fontSize: size * (1 / 2),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Akaya",
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        title: Text(
                          b.name,
                          style: TextStyle(
                            color: palette.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            b.relation != null
                                ? Text(
                                    b.reference != null
                                        ? "${b.relation!} -  ${b.reference!}"
                                        : b.relation!,
                                    style: TextStyle(
                                      color: palette.secondaryText,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatted,
                                  style: TextStyle(
                                    color: palette.secondaryText,
                                  ),
                                ),
                                Text(
                                  age != null
                                      ? (b.day == now.day &&
                                                b.month == now.month
                                            ? "Turned ${age + 1}"
                                            : "Turning ${age + 1}")
                                      : "",
                                  style: TextStyle(
                                    color: palette.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: SizedBox(
          height: 50,
          width: 50,
          child: FloatingActionButton(
            onPressed: () => _openAddBirthdaySheet(context),
            backgroundColor: palette.accentColor,
            foregroundColor: palette.backgroundColor,
            splashColor: palette.accentColor,
            shape: CircleBorder(),
            child: const Icon(Icons.add),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  DateTime _nextBirthday(Birthday b) {
    final now = DateTime.now();
    final thisYear = DateTime(now.year, b.month, b.day);
    return thisYear.isBefore(now)
        ? DateTime(now.year + 1, b.month, b.day)
        : thisYear;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _addSorted(List<_GroupedItem> list, List<Birthday> group) {
    group.sort((a, b) => a.day.compareTo(b.day));
    list.addAll(group.map((b) => _GroupedItem.birthday(b)));
  }

  void _openAddBirthdaySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 2 / 3,
            minChildSize: 0.5,
            maxChildSize: 0.90,
            expand: false,
            builder: (context, scrollController) {
              return AddBirthdayForm(
                scrollController: scrollController,
                onBirthdayAdded: fetchAndGroupBirthdays,
              );
            },
          ),
        );
      },
    );
  }

  void _openEditBirthdaySheet(BuildContext context, Birthday birthday) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 2 / 3,
            minChildSize: 0.5,
            maxChildSize: 0.90,
            expand: false,
            builder: (context, scrollController) {
              return AddBirthdayForm(
                scrollController: scrollController,
                existingBirthday: birthday,
                onBirthdayAdded: fetchAndGroupBirthdays,
              );
            },
          ),
        );
      },
    );
  }
}

class _GroupedItem {
  final String? header;
  final Birthday? birthday;

  _GroupedItem.header(this.header) : birthday = null;
  _GroupedItem.birthday(this.birthday) : header = null;

  bool get isHeader => header != null;
}
