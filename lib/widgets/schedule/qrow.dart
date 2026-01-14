import 'package:flutter/material.dart';
import 'package:svitlo/helpers/ext_methods.dart';
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
    // final int currentHour = DateTime.now().hour;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${queue.name} черга',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 4),
        singleQColumn(),
        // Container(height: 24, child: singleQRow(currentHour)),
        SizedBox(height: 24),
      ],
    );
  }

  Column singleQColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...queue.outages.map((toElement) {
          return Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.orange,
            ),
            child: Row(
              children: [
                Text(
                  "${toElement.from.getFormatted()} - ${toElement.to!.getFormatted()}",
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                Spacer(),
                Text(
                  "(${toElement.to!.diffFormated(toElement.from)})",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            height: 32,
            width: double.maxFinite,
            alignment: Alignment.center,
          );
        })
      ],
    );
  }

  Row singleQRow(int currentHour) {
    return Row(
      children: [
        ...queue.scheduleItems.map(
          (hourData) => Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: currentHour == hourData.time.hour ? Border.all(color: Colors.white, width: 1) : null,
                color: getTileColor(hourData),
              ),
              alignment: Alignment.center,
              child: Text(
                '${hourData.time.hour}',
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
              width: double.infinity,
              height: 16,
              margin: EdgeInsets.symmetric(horizontal: 1),
            ),
          ),
        ),
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
