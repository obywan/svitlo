import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/schedule_provider.dart';
import '../widgets/schedule/qrow.dart';

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
        onRefresh: (() => sp.generateSchedule()),
        child: _getScrollViewWithQueue(sp),
      ),
    );
  }

  SingleChildScrollView _getScrollViewWithQueue(ScheduleProvider sp) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: FutureBuilder(
          future: sp.generateSchedule(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return sp.scheduleResponse == null
                  ? Center(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Не вдалось отримати графік'),
                        checkTOEWebsite(),
                      ],
                    ))
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(DateFormat('d MMMM y').format(sp.scheduleResponse!.fact.data.date)),
                        SizedBox(
                          height: 16,
                        ),
                        // _topTimeRow(context, sp.qSchedule[0]),
                        ...sp.scheduleResponse!.fact.data.gpvList
                            .map((e) => QRow(
                                  queue: e,
                                ))
                            .toList(),
                        SizedBox(
                          height: 8,
                        ),
                        checkTOEWebsite(),
                        // AdBanner(),
                      ],
                    );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  TextButton checkTOEWebsite() {
    return TextButton(
        onPressed: () {
          _launchUrl('https://www.toe.com.ua/news/71');
        },
        child: Text('Перевірити графік на сайті'));
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw Exception('Could not launch $_url');
    }
  }
}
