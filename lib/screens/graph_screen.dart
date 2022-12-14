import 'package:flutter/material.dart';
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
      appBar: AppBar(title: Text('Графік')),
      body: RefreshIndicator(
        onRefresh: (() => sp.fetchAndSet()),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_topTimeRow(context, sp.schedule[0]), ...sp.schedule.map((e) => ScheduleRow(power_schedule_day: e)).toList()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topTimeRow(BuildContext context, PowerScheduleDay psd) {
    return Row(
      children: [],
    );
  }
}
