import 'package:collection/collection.dart';
import 'package:condo/resources.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../providers/state_provider.dart';

class History extends StatefulWidget {
  History({
    Key? key,
    required this.sheetController,
    this.currency: '£',
  }) : super(key: key);

  final SolidController sheetController;
  final String currency;

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  PageController pageController = PageController();

  DateTime startDate = DateTime.now();
  DateTime? endDate;
  int page = 0;
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<StateProvider>(context);
    return SolidBottomSheet(
      minHeight: 0,
      showOnAppear: appState.sheetInFocus,
      controller: widget.sheetController,
      maxHeight: MediaQuery.of(context).size.height * 0.58,
      canUserSwipe: page == 0,
      toggleVisibilityOnTap: page == 0,
      headerBar: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        height: 65,
        padding: EdgeInsets.only(top: 8),
        child: AppBar(
          title: Row(
            children: [
              GestureDetector(
                onTap: page == 1
                    ? () {
                        setState(() {
                          page = 0;
                        });
                        pageController.animateToPage(0,
                            duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
                      }
                    : null,
                child: Icon(
                  appState.sheetInFocus
                      ? page == 1
                          ? Icons.close
                          : Icons.keyboard_arrow_down_outlined
                      : Icons.keyboard_arrow_up_outlined,
                  size: 24,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                appState.sheetInFocus
                    ? page == 1
                        ? "${Jiffy(startDate).format('dd MMM${endDate != null ? "" : ", yyyy"}')} ${endDate != null ? " - ${Jiffy(endDate).format('dd MMM, yyyy')}" : ''} "
                        : '07 Apr, 2021'
                    : 'History transactions',
                style: Theme.of(context)
                    .primaryTextTheme
                    .bodyText1!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
              )
            ],
          ),
          actions: [
            if (appState.sheetInFocus)
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: page == 1 ? 0 : 44,
                    width: page == 1 ? 0 : 48,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).indicatorColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Icon(
                      Icons.search_rounded,
                      size: page == 1 ? 0 : 24,
                    ),
                  ),
                ),
              ),
            if (appState.sheetInFocus) SizedBox(width: 11),
            if (appState.sheetInFocus)
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      page == 0 ? page = 1 : page = 0;
                    });
                    pageController.animateToPage(page,
                        duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: 44,
                    width: 48,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).indicatorColor,
                        gradient: page == 1
                            ? LinearGradient(begin: Alignment.bottomLeft, colors: [
                                Color(0xffFFD60A),
                                Color(0xff32D74B),
                              ])
                            : null,
                        borderRadius: BorderRadius.circular(12)),
                    child: page == 0
                        ? ImageIcon(
                            AssetImage('assets/images/calendar.png'),
                            size: 24,
                          )
                        : Icon(
                            Icons.check,
                            size: 24,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            if (appState.sheetInFocus) SizedBox(width: 16),
          ],
        ),
      ),
      body: Container(
          color: Theme.of(context).cardColor,
          child: PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  Map<String, String> transaction = transactions[index];
                  Map groupByDate = groupBy(transactions, (Map obj) => obj['date']);
                  var item = groupByDate.entries
                      .firstWhere((e) => e.key == transaction['date'])
                      .value
                      .first;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (transaction['date'] != '07 Apr, 2021' && item == transaction)
                        Padding(
                          padding: const EdgeInsets.only(left: 75.0),
                          child: Text(transaction['date']!),
                        ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundImage:
                              AssetImage('assets/images/${transaction['name']!.toLowerCase()}.png'),
                        ),
                        title: Text(
                          transaction['name']!,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .bodyText1!
                              .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          transaction['brand']!,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${transaction['type'] == 'debit' ? '- ' : ''}${transaction['amount']} ${widget.currency}",
                              style: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(
                                  fontSize: 16,
                                  color: transaction['type'] == 'credit' ? Color(0xff32D74B) : null,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Text(transaction['time']!,
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 14,
                                    ))
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              SfDateRangePicker(
                view: DateRangePickerView.month,
                navigationMode: DateRangePickerNavigationMode.scroll,
                maxDate: DateTime.now(),
                monthFormat: 'MMM',
                allowViewNavigation: false,
                headerStyle: DateRangePickerHeaderStyle(
                    backgroundColor: Theme.of(context).cardColor,
                    textStyle:
                        Theme.of(context).primaryTextTheme.bodyText1!.copyWith(fontSize: 16)),
                selectionShape: DateRangePickerSelectionShape.circle,
                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(fontSize: 16),
                  todayTextStyle:
                      Theme.of(context).primaryTextTheme.bodyText1!.copyWith(fontSize: 16),
                ),
                selectionRadius: 30,
                todayHighlightColor: Theme.of(context).primaryTextTheme.bodyText1!.color,
                rangeSelectionColor:
                    Theme.of(context).primaryTextTheme.bodyText1!.color!.withOpacity(0.3),
                startRangeSelectionColor: Theme.of(context).primaryTextTheme.bodyText1!.color,
                endRangeSelectionColor: Theme.of(context).primaryTextTheme.bodyText1!.color,
                selectionTextStyle: TextStyle(fontSize: 16, color: Theme.of(context).cardColor),
                rangeTextStyle: TextStyle(fontSize: 16, color: Theme.of(context).cardColor),
                monthViewSettings: DateRangePickerMonthViewSettings(
                    firstDayOfWeek: 1,
                    viewHeaderHeight: 40,
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        backgroundColor: Theme.of(context).indicatorColor,
                        textStyle: TextStyle(color: Color(0xff8E8E93), fontSize: 16))),
                selectionMode: DateRangePickerSelectionMode.range,
                enableMultiView: true,
                navigationDirection: DateRangePickerNavigationDirection.vertical,
                onSelectionChanged: (value) {
                  setState(() {
                    startDate = value.value.startDate;
                    endDate =
                        value.value.endDate == value.value.startDate ? null : value.value.endDate;
                  });
                },
              ),
            ],
          )),
    );
  }
}
