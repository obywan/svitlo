import 'package:flutter/material.dart';

class GraphScreen extends StatefulWidget {
  static const String routeName = '/graph';
  const GraphScreen({Key? key}) : super(key: key);

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Графік')),
      body: SingleChildScrollView(
        child: Center(),
      ),
    );
  }
}
