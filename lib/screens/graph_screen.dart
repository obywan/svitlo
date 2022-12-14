import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:svitlo/models/power_schedule_day.dart';
import 'package:svitlo/providers/schedule_provider.dart';
import 'package:svitlo/widgets/schedule/schedule_row.dart';

class GraphScreen extends StatefulWidget {
  static const String routeName = '/graph';
  const GraphScreen({Key? key}) : super(key: key);

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  @override
  Widget build(BuildContext context) {
    ScheduleProvider sp = Provider.of<ScheduleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Графік'),
        actions: [
          IconButton(
              onPressed: () => (showModalBottomSheet(
                    context: context,
                    builder: (_) => Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                          'Щоб зренерувати новий графік, натисніть на верхню ліву комірку (перший квадратик понеділка) і виберіть значення, як в офіційнгму графіку'),
                    ),
                  )),
              icon: Icon(Icons.help))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: (() => sp.fetchAndSet()),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 16,
                ),
                _topTimeRow(context, sp.schedule[0]),
                ...sp.schedule.map((e) => ScheduleRow(power_schedule_day: e)).toList(),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topTimeRow(BuildContext context, PowerScheduleDay psd) {
    return Row(
      children: [
        SizedBox(width: 42),
        ...psd.items
            .map((e) => Flexible(
                  child: Container(
                    width: double.infinity,
                    height: 16,
                    margin: EdgeInsets.only(left: 2),
                    child: Text(
                      '${e.time.hour}-${e.time.hour + 3}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ))
            .toList()
      ],
    );
  }
}
