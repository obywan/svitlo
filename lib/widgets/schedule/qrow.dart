import 'package:flutter/material.dart';
import 'package:svitlo/models/power_schedule_day.dart';
import 'package:svitlo/models/queueschedule.dart';

class QRow extends StatelessWidget {
  final GPV queue;
  const QRow({
    Key? key,
    required this.queue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int currentHour = DateTime.now().hour;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${queue.name} черга'),
        Container(
            height: 24,
            child: Row(
              children: [
                ...queue.scheduleItems.map(
                  (toElement) => Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: currentHour == toElement.time.hour ? Border.all(color: Colors.white, width: 1) : null,
                        color: getTileColor(toElement),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${toElement.time.hour}',
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                      width: double.infinity,
                      height: 16,
                      margin: EdgeInsets.symmetric(horizontal: 1),
                    ),
                  ),
                ),
              ],
            )),
        SizedBox(height: 24),
      ],
    );
  }

  MaterialColor getTileColor(ScheduleItem toElement) {
    switch (toElement.value) {
      case -1:
        return Colors.red;
      case 0:
        return Colors.yellow;
      case 1:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
