import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svitlo/helpers/api_request_helper.dart';
import 'package:svitlo/helpers/app_settings.dart';
import 'package:svitlo/models/point_item.dart';
import 'package:svitlo/providers/points_provider.dart';
import 'package:svitlo/screens/map_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PointsProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SvitloApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {MapScreen.routeName: (_) => const MapScreen()},
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer<PointsProvider>(
      builder: ((context, value, child) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () => Navigator.of(context).pushNamed(MapScreen.routeName),
                )
              ],
              title: const Text('Svitlo'),
            ),
            body: Center(
              child: getList(value),
            )

            // },
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
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            showModalBottomSheet(context: context, builder: (__) => Image.network('${ApiRequestsHelper.baseUrl}${pp.points[index].graphUrl}'));
          },
          title: Text(pp.points[index].hostName),
          leading: Icon(
            Icons.circle,
            color: pp.points[index].active ? Colors.green : Colors.red,
          ),
          trailing: IconButton(
            icon: getStarIcon(pp, index),
            onPressed: () async {
              await pp.favTap(pp.points[index].hostId);
            },
          ),
        );
      },
      itemCount: pp.points.length,
    );
  }

  Icon getStarIcon(PointsProvider pp, int index) {
    return pp.isFav(pp.points[index].hostId)
        ? const Icon(
            Icons.star,
            color: Colors.amber,
          )
        : const Icon(Icons.star_border);
  }
}
