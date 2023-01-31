import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../providers/points_provider.dart';
import '../widgets/about.dart';
import '../widgets/active_dot.dart';
import '../widgets/fav_button.dart';
import '../widgets/graph_popup.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PointsProvider>(
      builder: ((context, value, child) {
        // ImageSaver.logPath();
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () => showModalBottomSheet(context: context, builder: (_) => About()),
              ),
            ],
            title: const Text('Список'),
          ),
          body: Center(
            child: getList(value),
          ),
        );
      }),
    );
  }

  Widget getList(PointsProvider pp) {
    if (pp.points.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (!pp.dataLoaded) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ой-йой, щось не так. Тут одне з двох:\n\n1. Або не вдалось отримати дані\n2. Або світла дійсно немає по всьому Тернополю'),
            SizedBox(height: 16),
            TextButton(
                onPressed: () {
                  launchUrlString('https://svitlo.ternopil.webcam');
                },
                child: Text('Перевірити, що показує сайт'))
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: (() => pp.getchAndSet()),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (__) => GraphPopup(point: pp.points[index]),
              );
            },
            title: Text(pp.points[index].hostName),
            subtitle: DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(pp.points[index].history.last.clock * 1000)).inMinutes > 10
                ? Text('оновлено: ${pp.points[index].updateTime}')
                : null,
            leading: ActiveDot(size: 16, active: pp.points[index].active),
            trailing: FavButton(
              favourite: pp.isFav(pp.points[index].hostId),
              onTap: () => pp.favTap(pp.points[index].hostId),
            ),
          );
        },
        itemCount: pp.points.length,
      ),
    );
  }
}
