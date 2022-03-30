import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../resources.dart';

class ExpenseIndicator extends StatelessWidget {

  final String title;
  final String icon;
  final String exp;
  final int selectedMonth;
  final Animation? animation;
  final Color color;

  const ExpenseIndicator({Key? key, this.title: 'Food', this.icon: 'food', this.exp: 'exp1', this.selectedMonth: 3, this.animation, this.color: const Color(0xff32D74B)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).cardColor,
        child: ImageIcon(
          AssetImage('assets/images/$icon.png'),
          size: 24,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .primaryTextTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Text(
            '- ${NumberFormat("###,###.00", "en_US").format(monthStatistics[selectedMonth][exp] * monthStatistics[selectedMonth]['total'])} £',
            style: Theme.of(context)
                .primaryTextTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: 0.6),
          ),
        ],
      ),
      subtitle: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LinearProgressIndicator(
          backgroundColor: Theme.of(context).canvasColor,

          value: monthStatistics[selectedMonth][exp] * animation!.value,
          color: color,
        ),
      ),
    );
  }
}