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
    return FutureBuilder<List<PointItem>>(
      future: Provider.of<PointsProvider>(context, listen: false).getchAndSet(),
      builder: ((_, snapshot) {
        final List<PointItem> data = snapshot.data == null ? [] : snapshot.data!;
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
          body: FutureBuilder<List<int>>(
            future: AppSettings.getFavs(),
            builder: (__, favsSnapshot) {
              if (favsSnapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: getList(data, favsSnapshot.data!),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
      }),
    );
  }

  Widget getList(List<PointItem> data, List<int> favsData) {
    if (data.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            showModalBottomSheet(context: context, builder: (__) => Image.network('${ApiRequestsHelper.baseUrl}${data[index].graphUrl}'));
          },
          title: Text(data[index].hostName),
          leading: Icon(
            Icons.circle,
            color: data[index].active ? Colors.green : Colors.red,
          ),
          trailing: IconButton(
            icon: Icon(favsData.contains(data[index].hostId) ? Icons.star_border : Icons.star),
            onPressed: () {
              if (favsData.contains(data[index].hostId)) {
                AppSettings.removeFromFavs(data[index].hostId);
              } else {
                AppSettings.addToFavs(data[index].hostId);
              }
            },
          ),
        );
      },
      itemCount: data.length,
    );
  }
}
