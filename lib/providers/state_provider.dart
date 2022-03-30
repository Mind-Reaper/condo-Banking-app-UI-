import 'package:flutter/material.dart';

class StateProvider with ChangeNotifier {
  int page = 0;
  PageController pageController = PageController();
  bool cardInFocus = false;
  bool sheetInFocus = false;
  late AnimationController _animationController;
   Animation animation = Tween(begin: 0.0, end: 1).animate(AlwaysStoppedAnimation(0));
  bool animationInitialized = false;

  initAnimation(TickerProvider ticker) {
    _animationController = AnimationController(duration: Duration(seconds: 1), vsync: ticker);
    animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    animation.addListener(() => notifyListeners());
    _animationController.forward();

  }



   animateForward() async {
    if(animationInitialized == false) {
      animationInitialized = true;
      notifyListeners();
    }
    if (animation.isCompleted) {
      _animationController.forward(from: 0);
    } else {
      await animation;
      _animationController.forward(from:  0);
    }
  }



  changeSheetFocus(bool value) {
    sheetInFocus = value;
    notifyListeners();
  }

  changeCardFocus(bool value) {
    cardInFocus = value;
    notifyListeners();
  }

  changePage(int index) {
    if (index < 0 || index > 2) {
      index = 0;
    }

    pageController.jumpToPage(index);
    page = index;
    notifyListeners();
  }
}
