import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  TabController tabController;
  GlobalKey bottomNavigationKey = GlobalKey();

  void changeTab(int page) {
    tabController.index = page;
    CurvedNavigationBarState state = bottomNavigationKey.currentState;
    state.setPage(page);
  }
}
