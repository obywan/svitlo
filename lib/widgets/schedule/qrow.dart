import 'package:flutter/material.dart';
import 'package:svitlo/models/queueschedule.dart';

class QRow extends StatelessWidget {
  final QueueSchedule queue;
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
        Text('${queue.queue}'),
        Container(
            height: 24,
            child: Row(
              children: [
                ...queue.hours.map(
                  (toElement) => Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: currentHour == toElement.time.hour
                            ? Border.all(color: Colors.white, width: 1)
                            : null,
                        color: toElement.value > 0 ? Colors.green : Colors.red,
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
}
