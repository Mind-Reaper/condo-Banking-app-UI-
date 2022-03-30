
import 'package:condo/pages/finance_extras.dart';
import 'package:condo/providers/state_provider.dart';
import 'package:condo/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

import '../widgets/debit_card.dart';
import 'history.dart';

class Finance extends StatefulWidget {
  const Finance({Key? key}) : super(key: key);

  @override
  _FinanceState createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  PageController pageController = PageController(viewportFraction: 0.80);
  double page = 1;

  SolidController sheetController = SolidController();

  @override
  void initState() {
    // TODO: implement initState
    var appState = Provider.of<StateProvider>(context, listen: false);

    super.initState();
    sheetController.addListener(() {
      appState.changeSheetFocus(sheetController.isOpened);
    });

    pageController.addListener(() {
      if (appState.cardInFocus == false) {
        if (pageController.page! > 0.5) {
          Future.microtask(() => appState.changeCardFocus(true));
        }
      } else {
        if (pageController.page! < 0.5) {
          Future.microtask(() {
            appState.changeCardFocus(false);
            appState.changeSheetFocus(false);
          });
        }
      }
      if(pageController.hasClients) {
        setState(() {
          page = pageController.page!;

        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    var appState = Provider.of<StateProvider>(context);
    return Scaffold(
      bottomSheet: appState.cardInFocus
          ? History( sheetController: sheetController,
        currency: page > 2.5 ? '¥' : page > 1.5 ? '€' : '£'
      )
          : null,
      appBar: appState.sheetInFocus
          ? null
          : AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: !appState.cardInFocus
                        ? () {
                            theme.changeTheme();
                          }
                        : null,
                    child: !appState.cardInFocus
                        ? Container(
                            height: 44,
                            width: 48,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: ImageIcon(
                              AssetImage('assets/images/settings.png'),
                              size: 24,
                            ),
                          )
                        : IconButton(
                            icon: Icon(Icons.arrow_back_rounded),
                            onPressed: () {
                              pageController.animateToPage(0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn);
                            },
                          ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        height: 54,
                        width: 54,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage('assets/images/border.png'))),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/picture.png'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
              titleSpacing: 0,
              actions: [
                Center(
                  child: GestureDetector(
                    onTap: !appState.cardInFocus
                        ? () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/security', (route) => route.isCurrent);
                          }
                        : null,
                    child: Container(
                      height: 44,
                      width: 48,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(
                        appState.cardInFocus ? Icons.add_circle_outline_rounded : Icons.logout,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
              ],
            ),
      body: SafeArea(
        left: false,
        bottom: false,
        right: false,
        top: appState.sheetInFocus,
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Container(
              height: 234,
              child: PageView(
                padEnds: false,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                        width: 252,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total balance', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 6),
                            Text(
                              '£ 23,970.30',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 32, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 32),
                            Text('This month', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(
                                  image: AssetImage('assets/images/income_up.png'),
                                  height: 15,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  '£ 5,235.25',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(
                                  image: AssetImage('assets/images/income_down.png'),
                                  height: 15,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  '£ 3,710.80',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                  DebitCard(
                    onTap: () {
                      pageController.animateToPage(1,
                          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
                    },
                    shrink: appState.sheetInFocus,
                  ),
                  DebitCard(
                    bright: true,
                    name: 'Europe travel',
                    number: '1882 8245 9831 0505',
                    date: '04 / 24',
                    cash: '€ 7,118.30',
                    issuer: 'visa',
                    color1: Color(0xffBF5AF2),
                    color2: Color(0xff5E5CE6),
                    shrink: appState.sheetInFocus,
                    onTap: () {
                      pageController.animateToPage(2,
                          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
                    },
                  ),
                  DebitCard(
                    bright: true,
                    name: 'Tokyo travel',
                    number: '5367 1120 8905 0177',
                    date: '08 / 25',
                    cash: '¥ 127,803.19',
                    issuer: 'mastercard',
                    color1: Color(0xffFF375F),
                    color2: Color(0xffFF9F0A),
                    shrink: appState.sheetInFocus,
                    onTap: () {
                      pageController.animateToPage(3,
                          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
                    },
                  ),
                ],
                controller: pageController,
              ),
            ),
            SizedBox(height: 8,),
            SmoothPageIndicator(
              controller: pageController,
              count: 4,
              onDotClicked: (index) {
                pageController.animateToPage(index,
                    duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
              },
              effect:
                  ExpandingDotsEffect(dotHeight: 8, dotWidth: 8, activeDotColor: Color(0xff32d74b)),
            ),
            SizedBox(height: 24,),
            FinanceOptions(controller: pageController,
              currency: page > 2.5 ? '¥' : page > 1.5 ? '€' : '£',
              color1: page > 2.5 ? Color(0xffFF375F) : page > 1.5 ?   Color(0xffBF5AF2):   Color(0xff32D74B),
              color2: page > 2.5 ? Color(0xffFF9F0A) : page > 1.5 ?   Color(0xff5E5CE6):   Color(0xffFFD60A),
            ),
          ],
        ),
      ),
    );
  }
}


