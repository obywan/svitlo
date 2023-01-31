import 'package:flutter/material.dart';

class GraphTutorial extends StatelessWidget {
  const GraphTutorial({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          Text('Відкрийте офіційний графік (як на зображенні) і в ньому подивіться, який колір для вашої групи на початку понеділка (00:00-03:00)'),
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
    );
  }
}
