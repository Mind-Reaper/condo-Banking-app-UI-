import 'package:condo/pages/chatbot.dart';
import 'package:condo/pages/statistics.dart';
import 'package:condo/providers/state_provider.dart';
import 'package:condo/widgets/keep_alive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/finance.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<StateProvider>(context);
    return Scaffold(
      body: PageView(
        controller: appState.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          KeepAlivePage(child: Finance()),
          KeepAlivePage(child: Statistics()),
          KeepAlivePage(child: ChatBot()),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(appState.cardInFocus ||  appState.page == 2? 0 :  24)),
        child: Theme(
          data: Theme.of(context)
              .copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
          child: BottomNavigationBar(
            currentIndex: appState.page,
            backgroundColor: Theme.of(context).cardColor,
            unselectedIconTheme: Theme.of(context).primaryIconTheme,
            selectedIconTheme: Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) {
              appState.changePage(index);
            },
            items: [
              BottomNavigationBarItem(
                  label: 'Finance',
                  icon: Container(
                    height: 44,
                    width: 107,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: appState.page == 0
                            ? LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                    Color(0xffFFD60A),
                                    Color(0xff32D74B),
                                  ])
                            : null),
                    child: Center(
                      child: ImageIcon(
                        AssetImage('assets/images/finance.png'),
                        size: 24,
                      ),
                    ),
                  )),
              BottomNavigationBarItem(
                  label: 'Statistics',
                  icon: Container(
                    height: 44,
                    width: 107,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: appState.page == 1
                            ? LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                    Color(0xffFF9F0A),
                                    Color(0xffFF375F),
                                  ])
                            : null),
                    child: Center(
                      child: ImageIcon(
                        AssetImage('assets/images/ordinal.png'),
                        size: 24,
                      ),
                    ),
                  )),
              BottomNavigationBarItem(
                  label: 'Chat Bot',
                  icon: Container(
                    height: 44,
                    width: 107,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: appState.page == 2
                            ? LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                    Color(0xff64D2FF),
                                    Color(0xff5E5CE6),
                                  ])
                            : null),
                    child: Center(
                      child: ImageIcon(
                        AssetImage('assets/images/chatbot.png'),
                        size: 24,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
