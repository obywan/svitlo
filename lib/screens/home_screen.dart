import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/points_provider.dart';
import '../widgets/active_dot.dart';
import '../widgets/fav_button.dart';
import '../widgets/graph_popup.dart';
import 'graph_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<PointsProvider>(
      builder: ((context, value, child) {
        // ImageSaver.logPath();
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.map),
                onPressed: () => Navigator.of(context).pushNamed(MapScreen.routeName),
              ),
              IconButton(
                icon: const Icon(Icons.auto_graph_sharp),
                onPressed: () => Navigator.of(context).pushNamed(GraphScreen.routeName),
              ),
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text('На основі даних сайту svitlo.ternopil.webcam'),
                            ),
                            SizedBox(
                              height: 16,
                            )
                          ],
                        )),
              ),
            ],
            title: const Text('Де світло'),
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
      return const Center(
        child: Text('Ой-йой, щось не так. Тут одне з двох:\n\n1. Або дані некоректно завантажились\n2. Або світла дійсно немає по всьому Тернополю'),
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
