import 'package:flutter/material.dart';

import '../../models/power_schedule_day.dart';

class ScheduleRow extends StatelessWidget {
  final PowerScheduleDay power_schedule_day;
  const ScheduleRow({Key? key, required this.power_schedule_day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (_) => Padding(
                    padding: EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: getColor(i.value),
                        ),
                        SizedBox(width: 16),
                        Text(
                            '${_getDaySrt(day)}, ${i.time.format(context)} - ${TimeOfDay(hour: i.time.hour + 3, minute: 0).format(context)}:\n${_getavailabilityText(i.value)}'),
                      ],
                    ),
                  ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: !thisTimeslot ? Border.all(color: c, width: 2) : null,
            color: !thisTimeslot ? Colors.transparent : c,
          ),
          width: 36,
          height: 36,
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
        return '????';
      case 1:
        return '????';
      case 2:
        return '????';
      case 3:
        return '????';
      case 4:
        return '????';
      case 5:
        return '????';
      case 6:
        return '????';
    }
    return '';
  }

  String _getavailabilityText(int i) {
    switch (i) {
      case -1:
        return '???????????? ???? ????????';
      case 0:
        return '???????? ????????, ???????? ????';
      case 1:
        return '?????? ????????';
    }
    return '??????, ?????????? ??????????????';
  }
}
