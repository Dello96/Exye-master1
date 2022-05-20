import 'package:exye_app/utils.dart';

class CalendarData {
  Month? prev;
  Month? current;
  Month? next;
  int month;
  CalendarData(this.month, {this.prev, this.current, this.next});

  void setPrev (Month month) {
    prev = month;
  }

  void setCurrent (Month month) {
    current = month;
  }

  void setNext (Month month) {
    next = month;
  }
}

class Month {
  int year;
  int month;
  List<Timeslot> days = [];
  Month({required this.year, required this.month});

  void setDays (List<Timeslot> input) {
    days = input;
  }
}

class Timeslot {
  int year;
  int month;
  int day;
  int weekday;
  int available;
  List<String>? slots;
  Timeslot({required this.year, required this.month, required this.day, required this.weekday, required this.available, this.slots,});

  int isValid (int type) {
    if (DateTime.now().year == year && DateTime.now().month == month && DateTime.now().day == day) {
      return -1;
    }
    if (DateTime(year, month, day).isBefore(DateTime.now())) {
      return 0;
    }
    if (DateTime(year, month, day).isAfter(DateTime.now().add(const Duration(days: 30)))) {
      return 0;
    }
    if (app.mData.user!.order != null) {
      if (app.mData.user!.order!.year == year && app.mData.user!.order!.month == month && app.mData.user!.order!.day == day) {
        return 1;
      }
    }
    if (available == 0) {
      return 0;
    }
    return 1;
  }

  bool isSame (Timeslot? other) {
    if (other == null) {
      return false;
    }
    else if (other.year == year && other.month == month && other.day == day) {
      return true;
    }
    return false;
  }
}