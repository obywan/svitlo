import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Інформація про наявність чи відсутність електропостачання: на основі даних сайту svitlo.ternopil.webcam'),
          SizedBox(
            height: 16,
          ),
          Text(
            'Розробник: Олег Голодюк',
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
