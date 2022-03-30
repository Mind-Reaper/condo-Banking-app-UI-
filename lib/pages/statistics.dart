import 'package:carousel_slider/carousel_slider.dart';
import 'package:condo/providers/state_provider.dart';
import 'package:condo/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:intl/intl.dart';

import '../widgets/indicator.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> with SingleTickerProviderStateMixin {
  int tab = 0;
  int selectedDateType = 2;
  int selectedMonth = 3;
  AutoScrollController controller = AutoScrollController();
  CarouselController carouselController = CarouselController();
  ScrollController listController = ScrollController();

  @override
  void initState() {
    var appState = Provider.of<StateProvider>(context, listen: false);
    super.initState();
Future.microtask(() =>
    appState.initAnimation(this));
    controller.addListener(() {
      carouselController.animateToPage(selectedMonth, duration: Duration(milliseconds: 300));
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<StateProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tab = 0;
                      });
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          gradient: tab == 0
                              ? LinearGradient(colors: [Color(0xffFF9F0A), Color(0xffFF375F)])
                              : null,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text(
                        'Expense',
                        style: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: tab == 0 ? Colors.white : null),
                      )),
                    ),
                  ),
                ),
                SizedBox(width: 11),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tab = 1;
                      });
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          gradient: tab == 1
                              ? LinearGradient(colors: [Color(0xffFF9F0A), Color(0xffFF375F)])
                              : null,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text(
                        'Income',
                        style: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: tab == 1 ? Colors.white : null),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 50),
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 50,
                    child: ListView.separated(
                        itemCount: dateTypes.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) {
                          return SizedBox(width: 11);
                        },
                        itemBuilder: (context, index) {
                          String item = dateTypes[index];
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDateType = index;
                                });
                              },
                              child: Container(
                                width: 48,
                                height: 44,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    gradient: index == selectedDateType
                                        ? LinearGradient(
                                            colors: [Color(0xffFFD60A), Color(0xff32D74B)],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight)
                                        : null,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                    child: item != 'calendar'
                                        ? Text(
                                            item,
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .bodyText1!
                                                .copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: index == selectedDateType
                                                        ? Colors.white
                                                        : null),
                                          )
                                        : ImageIcon(
                                            AssetImage('assets/images/calendar.png'),
                                            size: 24,
                                            color: index == selectedDateType ? Colors.white : null,
                                          )),
                              ),
                            ),
                          );
                        }),
                  )),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            controller: listController,
            children: [
              SizedBox(height: 20),
              Container(
                height: 300,
                child: ListView.builder(
                  itemCount: monthStatistics.length,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> month = monthStatistics[index];
                    List<Map<String, dynamic>> values = [];
                    values.add({'exp': month['exp1'], 'color': 0xff32D74B});
                    values.add({'exp': month['exp2'], 'color': 0xffBF5AF2});
                    values.add({'exp': month['exp3'], 'color': 0xffFF9F0A});
                    values.add({'exp': month['exp4'], 'color': 0xff64D2FF});
                    values.sort((a, b) => b['exp']!.compareTo(a['exp']!));
                    return AutoScrollTag(
                      key: ValueKey(index),
                      controller: controller,
                      index: index,
                      highlightColor: Colors.transparent,
                      child: Opacity(
                        opacity: selectedMonth == index ? 1 : 0.3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.5),
                          child: GestureDetector(
                            onTap: () {
                              listController.animateTo(0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn);
                              controller.scrollToIndex(index,
                                  preferPosition: AutoScrollPosition.middle);
                              setState(() {
                                selectedMonth = index;
                              });

                              appState.animateForward();
                            },
                            child: Container(
                              height: 248,
                              width: 48,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: (values[0]['exp']! * 1000).toInt(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(values[0]['color']),
                                          borderRadius: BorderRadius.circular(24)),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Expanded(
                                    flex: (values[1]['exp']! * 1000 * (appState.animationInitialized ? 1 : appState.animation.value))
                                        .toInt(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(values[1]['color']),
                                          borderRadius: BorderRadius.circular(24)),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Expanded(
                                    flex: (values[2]['exp']! * 1000 * (appState.animationInitialized ? 1 : appState.animation.value))
                                        .toInt(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(values[2]['color']),
                                          borderRadius: BorderRadius.circular(24)),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Expanded(
                                    flex: (values[3]['exp']! * 1000 * (appState.animationInitialized ? 1 : appState.animation.value))
                                        .toInt(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(values[3]['color']),
                                          borderRadius: BorderRadius.circular(24)),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    month['month'],
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyText1!
                                        .copyWith(fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
              Center(
                  child: Text(
                'Total expenses',
                style: TextStyle(fontSize: 16),
              )),
              SizedBox(height: 8),
              CarouselSlider.builder(
                  carouselController: carouselController,
                  itemCount: monthStatistics.length,
                  itemBuilder: (context, index, index2) {
                    double value = monthStatistics[index]['total'];
                    String total = NumberFormat("###,###.00", "en_US").format(value);
                    return Opacity(
                      opacity: index == selectedMonth ? 1 : 0.3,
                      child: Text(
                        "£ $total",
                        style: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(
                            fontSize: index == selectedMonth ? 32 : 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6),
                      ),
                    );
                  },
                  options: CarouselOptions(
                      height: 40,
                      scrollPhysics: NeverScrollableScrollPhysics(),
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.55,
                      initialPage: 3)),
              SizedBox(height: 8),
              if (monthStatistics[selectedMonth]['exp1'] != 0)
                ExpenseIndicator(
                    title: 'Food',
                    color: Color(0xff32D74B),
                    exp: 'exp1',
                    icon: 'food',
                    selectedMonth: selectedMonth,
                    animation: appState.animation),
              if (monthStatistics[selectedMonth]['exp2'] != 0)
                ExpenseIndicator(
                    title: 'Shopping',
                    color: Color(0xffBF5AF2),
                    exp: 'exp2',
                    icon: 'shopping',
                    selectedMonth: selectedMonth,
                    animation: appState.animation),
              if (monthStatistics[selectedMonth]['exp3'] != 0)
                ExpenseIndicator(
                    title: 'Restaurants & Cafes',
                    color: Color(0xffFF9F0A),
                    exp: 'exp3',
                    icon: 'cafe',
                    selectedMonth: selectedMonth,
                    animation: appState.animation),
              if (monthStatistics[selectedMonth]['exp4'] != 0)
                ExpenseIndicator(
                    title: 'Health',
                    color: Color(0xff64D2FF),
                    exp: 'exp4',
                    icon: 'health',
                    selectedMonth: selectedMonth,
                    animation: appState.animation),
            ],
          ),
        ));
  }
}
