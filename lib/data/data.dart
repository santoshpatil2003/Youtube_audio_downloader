// import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Data with ChangeNotifier {
  int chose = -1;
  String search = "";
  bool show = false;
  void change(ch) {
    chose = ch;
    notifyListeners();
  }

  void sea(sear) {
    search = sear;
    show = true;
    notifyListeners();
  }
}
