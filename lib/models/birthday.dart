class Birthday {
  final int? id;
  final String name;
  final int day;
  final int month;
  final int? year;
  final int? age;
  final String? relation;
  final String? reference;
  final String? whatsapp;
  final String? email;
  final String? instagram;
  final Duration? remindBefore;

  Birthday({
    this.id,
    required this.name,
    required this.day,
    required this.month,
    this.relation,
    this.reference,
    this.year,
    this.age,
    this.whatsapp,
    this.email,
    this.instagram,
    this.remindBefore,
  });

  int? get calculatedYear {
    if (year != null) return year;
    if (age != null) {
      final now = DateTime.now();
      return now.year - age!;
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'day': day,
      'month': month,
      'year': year,
      'age': age,
      'relation': relation,
      'reference': reference,
      'whatsapp': whatsapp,
      'email': email,
      'instagram': instagram,
      'remindBefore': remindBefore?.inMinutes ?? 0,
    };
  }

  factory Birthday.fromMap(Map<String, dynamic> map) {
    return Birthday(
      id: map['id'],
      name: map['name'],
      day: map['day'],
      month: map['month'],
      year: map['year'],
      age: map['age'],
      relation: map['relation'],
      reference: map['reference'],
      whatsapp: map['whatsapp'],
      email: map['email'],
      instagram: map['instagram'],
      remindBefore: Duration(minutes: map['remindBefore'] ?? 0),
    );
  }

  int? get calculatedAge {
    if (age != null) return age;
    if (year != null) {
      final today = DateTime.now();
      int calculated = today.year - year!;
      if (today.month < month || (today.month == month && today.day < day)) {
        calculated--;
      }
      return calculated;
    }
    return null;
  }

  DateTime? get fullDate {
    final y = calculatedYear;
    return (y != null) ? DateTime(y, month, day) : null;
  }

  String get formattedDate => "$day/${month.toString().padLeft(2, "0")}";
}
