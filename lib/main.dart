import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svitlo/providers/schedule_provider.dart';

import 'providers/points_provider.dart';
import 'screens/graph_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';

void main() {
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
      title: 'SvitloApp',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(title: 'Flutter Demo Home Page'),
      routes: {
        MapScreen.routeName: (_) => const MapScreen(),
        GraphScreen.routeName: (_) => const GraphScreen(),
      },
    );
  }
}
