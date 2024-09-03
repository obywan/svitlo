import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'providers/points_provider.dart';
import 'providers/schedule_provider.dart';
import 'screens/graph_screen.dart';
import 'screens/map_screen.dart';
import 'screens/tabs_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // UnityAds.init(
  //   gameId: '5682683',
  //   testMode: true,
  //   onComplete: () => print('Initialization Complete'),
  //   onFailed: (error, message) =>
  //       print('Initialization Failed: $error $message'),
  // );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PointsProvider()),
        ChangeNotifierProvider(
          create: (_) => ScheduleProvider(),
          lazy: false,
        ),
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
      title: 'Де світло',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const TabsScreen(),
      routes: {
        MapScreen.routeName: (_) => const MapScreen(),
        GraphScreen.routeName: (_) => const GraphScreen(),
      },
    );
  }
}
