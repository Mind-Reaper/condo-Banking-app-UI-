import 'package:flutter/material.dart';

class Option extends StatelessWidget {
  final String title;
  final String icon;

  const Option({Key? key, this.title = 'transfer', this.icon = 'transfer'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 44,
          width: 107,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(10),
          child: ImageIcon(
            AssetImage('assets/images/$icon.png'),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          title == 'atm'
              ? title.toUpperCase()
              : "${title[0].toUpperCase()}${title.substring(1).toLowerCase()}",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}