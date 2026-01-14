import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/schedule_provider.dart';
import '../widgets/graph_tutorial.dart';

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
    // checkTutorial();
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
}
