import 'package:flutter/material.dart';
import 'package:svitlo/models/power_schedule_day.dart';
import 'package:svitlo/widgets/schedule_change_dialog.dart';

class ScheduleRow extends StatelessWidget {
  final PowerScheduleDay power_schedule_day;
  const ScheduleRow({Key? key, required this.power_schedule_day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              _getDaySrt(power_schedule_day.day),
            ),
          ),
          ...power_schedule_day.items.map((e) => _getSpan(context, power_schedule_day.day, e)).toList(),
        ],
      ),
    );
  }

  Widget _getSpan(BuildContext context, int day, ScheduleItem i) {
    final Color c = getColor(i.value);
    final DateTime now = DateTime.now();
    final bool thisTimeslot = now.weekday == day + 1 && now.hour >= i.time.hour && now.hour < i.time.hour + 3;
    return Flexible(
      child: InkWell(
        onTap: (day == 0 && i.time.hour == 0) ? () => showModalBottomSheet(context: context, builder: (_) => ScheduleChangeDialog()) : () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: !thisTimeslot ? Border.all(color: c, width: 2) : null,
            color: !thisTimeslot ? Colors.transparent : c,
          ),
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.only(left: 2),
        ),
      ),
    );
  }

  static Color getColor(int i) {
    switch (i) {
      case -1:
        return Colors.red[900]!;
      case 0:
        return Colors.amber[700]!;
      case 1:
        return Colors.green[800]!;
    }
    return Colors.grey;
  }

  String _getDaySrt(int i) {
    switch (i) {
      case 0:
        return 'Пн';
      case 1:
        return 'Вт';
      case 2:
        return 'Ср';
      case 3:
        return 'Чт';
      case 4:
        return 'Пт';
      case 5:
        return 'Сб';
      case 6:
        return 'Нд';
    }
    return '';
  }
}
