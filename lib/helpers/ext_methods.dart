import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TimeUtils on TimeOfDay {
  String getFormatted() {
    final dt = DateTime(2026, 1, 1, this.hour, this.minute);
    return DateFormat.Hm().format(dt);
  }

  String diffFormated(TimeOfDay other) {
    final dt = DateTime(2026, 1, 1, this.hour, this.minute);
    final dt2 = DateTime(2026, 1, 1, other.hour, other.minute);
    final duration = dt.difference(dt2);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')} год ${minutes.toString().padLeft(2, '0')} хв';
  }
}
