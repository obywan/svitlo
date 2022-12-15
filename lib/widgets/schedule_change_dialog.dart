import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/schedule_provider.dart';
import 'schedule/schedule_row.dart';

class ScheduleChangeDialog extends StatelessWidget {
  const ScheduleChangeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScheduleProvider sp = Provider.of<ScheduleProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Що показує офіційний графік відключень на 00:00 - 03:00 в Понеділок?',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          _getButton(context, sp, -1, 'Світла немає'),
          _getButton(context, sp, 0, 'Може не бути'),
          _getButton(context, sp, 1, 'Світло є'),
        ],
      ),
    );
  }

  Widget _getButton(BuildContext context, ScheduleProvider sp, int num, String text) {
    return TextButton.icon(
      onPressed: () {
        sp.updateInitSchedule(num).then((value) => Navigator.of(context).pop());
      },
      label: Text(text),
      icon: Icon(
        Icons.lightbulb,
        color: ScheduleRow.getColor(num),
      ),
    );
  }
}
