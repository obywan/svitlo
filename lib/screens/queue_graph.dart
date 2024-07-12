import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../helpers/app_settings.dart';
import '../models/queueschedule.dart';

import '../providers/schedule_provider.dart';
import '../widgets/graph_tutorial.dart';
import '../widgets/schedule/qrow.dart';
import '../widgets/schedule/schedule_row.dart';
import '../widgets/schedule_change_dialog.dart';

class QueueGraph extends StatefulWidget {
  static const String routeName = '/graph';
  const QueueGraph({Key? key}) : super(key: key);

  @override
  State<QueueGraph> createState() => _QueueGraphState();
}

class _QueueGraphState extends State<QueueGraph> {
  @override
  Widget build(BuildContext context) {
    ScheduleProvider sp = Provider.of<ScheduleProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Графік')),
      body: RefreshIndicator(
        onRefresh: (() => sp.fetchAndSet()),
        child: SingleChildScrollView(
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
                      // _topTimeRow(context, sp.qSchedule[0]),
                      ...sp.qSchedule
                          .map((e) => QRow(
                                queue: e,
                              ))
                          .toList(),
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

  Future<dynamic> _getModalWindow(BuildContext context) {
    return showModalBottomSheet(
        context: context, builder: (_) => ScheduleChangeDialog());
  }

  Widget _topTimeRow(BuildContext context, QueueSchedule psd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...psd.hours
            .map((e) => Flexible(
                  child: Container(
                    width: double.infinity,
                    height: 16,
                    margin: EdgeInsets.only(left: 2),
                    child: Text(
                      '${e.time.hour}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ))
            .toList()
      ],
    );
  }
}
