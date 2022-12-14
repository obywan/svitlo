import 'package:flutter/material.dart';
import 'package:svitlo/models/power_schedule_day.dart';

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
          Text(_getDaySrt(power_schedule_day.day)),
          ...power_schedule_day.items.map((e) => _getSpan(e)).toList(),
        ],
      ),
    );
  }

  Widget _getSpan(ScheduleItem i) {
    final Color c = _getColor(i.value);
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: c,
        ),
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(left: 2),
      ),
    );
  }

  Color _getColor(int i) {
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
