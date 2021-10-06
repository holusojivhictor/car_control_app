import 'package:flutter/cupertino.dart';

class HomeController extends ChangeNotifier {

  int selectedBottomTab = 0;

  void onBottomNavigationBarChange(int index) {
    selectedBottomTab = index;
    notifyListeners();
  }

  bool isRightDoorLocked = true;
  bool isLeftDoorLocked = true;
  bool isFrontDoorLocked = true;
  bool isTrunkDoorLocked = true;

  void updateRightDoorLock() {
    isRightDoorLocked = !isRightDoorLocked;
    notifyListeners();
  }

  void updateLeftDoorLock() {
    isLeftDoorLocked = !isLeftDoorLocked;
    notifyListeners();
  }

  void updateFrontDoorLock() {
    isFrontDoorLocked = !isFrontDoorLocked;
    notifyListeners();
  }

  void updateTrunkDoorLock() {
    isTrunkDoorLocked = !isTrunkDoorLocked;
    notifyListeners();
  }
}