# Cherish - Birthday Reminder App

**Cherish** is a beautifully crafted Flutter application designed to help users remember and celebrate birthdays with elegance. It supports both **Gregorian calendar** and **Hindu calendar** birthdays, offering a culturally inclusive and thoughtful experience.

---

## Features

**Add new birthday form**

-   Fully validated form with checks for invalid dates
-   Auto age calculation from birth year (and vice versa)
-   Customizable reminders with predefined durations

**Main Screen:**

-   Birthdays grouped under:
    -   Today
    -   Tomorrow
    -   Upcoming Months
-   Clear display of:
    -   Name
    -   Birth Date
    -   Age
    -   Relation
    -   Reference

---

## Storage:

Local Database: **SQLite**

```sql
CREATE TABLE birthdays (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  day INTEGER NOT NULL,
  month INTEGER NOT NULL,
  year INTEGER,
  age INTEGER,
  relation TEXT,
  reference TEXT,
  whatsapp TEXT,
  email TEXT,
  instagram TEXT,
  remindBefore INTEGER
);
```

---

## Tech Stack

<p align="left">
  <img src="https://img.icons8.com/color/48/flutter.png" width="40" alt="Flutter"/>
  <img src="https://img.icons8.com/color/48/dart.png" width="40" alt="Dart"/>
  <img src="https://img.icons8.com/ios-filled/48/4a90e2/sqlite.png" width="40" alt="SQLite"/>
</p>

---

## Project Structure (So far)

```
lib/
├── main.dart                        # Entry point of the application
├── layout.dart                      # Defines the overall layout and navigation structure
├── db/
│   └── birthday_database.dart       # Handles all database operations using SQLite
├── models/
│   └── birthday.dart                # Data model representing a birthday entry
├── screens/
│   ├── western_screen.dart          # Displays birthdays based on the Gregorian calendar
│   └── hindu_screen.dart            # Displays birthdays based on the Hindu calendar (Tithi-based)
├── utils/
│   ├── theme_controller.dart        # Manages theme switching between light and dark modes
│   └── theme.dart                   # Defines custom theme colors and styles
└── widgets/
    └── add_birthday_form.dart       # Bottom sheet widget for adding new birthday entries

```

---

## Planned Features

-   **Cloud Backup** – Sync birthdays to the cloud for safe storage
-   **Notifications** – Yearly repeating reminders
-   **Alarms** – Timed alerts alongside notifications
-   **Contact Integration** – One-tap messaging with pre-filled birthday wishes
-   **Sorting & Filtering** – Organize birthdays by relation, name, or date
-   **Hindu Calendar Support** – Enhanced tithi-based birthday tracking _(Planned for v2.0_)

---

## Vision

Cherish aims to blend modern utility with cultural sensitivity, making it easy to honor both conventional and traditional birthday observances. Whether you're tracking birthdays of loved ones or spiritual milestones, Cherish keeps you connected.
