import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/power_schedule_day.dart';
import '../providers/schedule_provider.dart';
import '../widgets/schedule/schedule_row.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text('Графік'), actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Як подивитись графік для своєї групи?'),
                        SizedBox(height: 16),
                        Text('В програмі не вказані групи, оскільки офіційний графік змінюється щотижня'),
                        SizedBox(height: 8),
                        Text('Але на основі офіційного графіку ви можете побудувати його копію тут (щоб було зручніше)'),
                        SizedBox(height: 8),
                        Text(
                            'Відкрийте офіційний графік (як на зображенні) і в ньому подивіться, який колір для вашої групи на початку понеділка (00:00-03:00)'),
                        SizedBox(height: 8),
                        Text('Тоді в програмі натисніть "Редагувати графік" і виберіть такий же колір. Графік оновиться на весь тиждень'),
                        SizedBox(height: 8),
                        Container(
                          height: 128,
                          child: Image.asset(
                            'assets/images/graph_off.png',
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    ),
                  )),
        ),
      ]),
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
                TextButton(onPressed: () => _getModalWindow(context), child: Text('Редагувати графік'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _getModalWindow(BuildContext context) {
    return showModalBottomSheet(context: context, builder: (_) => ScheduleChangeDialog());
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
