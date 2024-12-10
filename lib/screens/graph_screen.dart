import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/app_settings.dart';
import '../models/power_schedule_day.dart';
import '../providers/schedule_provider.dart';
import '../widgets/graph_tutorial.dart';
import '../widgets/schedule_change_dialog.dart';

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
    checkTutorial();
    return Scaffold(
      appBar: AppBar(title: Text('Графік'), actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => showModalBottomSheet(context: context, builder: (_) => GraphTutorial()),
        ),
      ]),
      body: RefreshIndicator(
        onRefresh: (() => sp.fetchAndSet()),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: FutureBuilder(
              future: sp.generateSchedule(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      // _topTimeRow(context, sp.schedule[0]),
                      // ...sp.schedule.map((e) => ScheduleRow(power_schedule_day: e)).toList(),
                      SizedBox(height: 32),
                      TextButton(onPressed: () => _getModalWindow(context), child: Text('Редагувати графік'))
                    ],
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _getModalWindow(BuildContext context) {
    return showModalBottomSheet(context: context, builder: (_) => ScheduleChangeDialog());
  }

  Future<void> checkTutorial() async {
    final tutorialSeen = await AppSettings.getTutorialSeen();
    if (!tutorialSeen) {
      showModalBottomSheet(context: context, builder: (_) => GraphTutorial());
    }
  }

  Widget _topTimeRow(BuildContext context, PowerScheduleDay psd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 48),
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
