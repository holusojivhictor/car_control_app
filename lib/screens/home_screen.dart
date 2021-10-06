import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gigi_control_app/constants.dart';
import 'package:gigi_control_app/home_controller.dart';

import 'components/battery_status.dart';
import 'components/bottom_navigation_bar.dart';
import 'components/door_lock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  void setupBatteryAnimation() {
    _batteryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animationBattery = CurvedAnimation(
      parent: _batteryAnimationController,
      curve: const Interval(0.0, 0.5),
    );

    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationController,
      curve: const Interval(0.6, 1),
    );
  }

  @override
  void initState() {
    setupBatteryAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _batteryAnimationController]),
      builder: (context, _) {
        return Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(
            onTap: (index) {
              if (index == 1) {
                _batteryAnimationController.forward();
              } else if (_controller.selectedBottomTab == 1 && index != 1) {
                _batteryAnimationController.reverse(from: 0.7);
              }
              _controller.onBottomNavigationBarChange(index);
            },
            selectedTab: _controller.selectedBottomTab,
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.1),
                      child: SvgPicture.asset("assets/icons/Car.svg", width: double.infinity),
                    ),
                    AnimatedPositioned(
                      duration: kDuration,
                      right: _controller.selectedBottomTab == 0
                          ? constraints.maxWidth * 0.05
                          : constraints.maxWidth / 2,
                      child: AnimatedOpacity(
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        duration: kDuration,
                        child: DoorLock(
                          isLock: _controller.isRightDoorLocked,
                          press: _controller.updateRightDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: kDuration,
                      left: _controller.selectedBottomTab == 0
                          ? constraints.maxWidth * 0.05
                          : constraints.maxWidth / 2,
                      child: AnimatedOpacity(
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        duration: kDuration,
                        child: DoorLock(
                          isLock: _controller.isLeftDoorLocked,
                          press: _controller.updateLeftDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: kDuration,
                      top: _controller.selectedBottomTab == 0
                          ? constraints.maxHeight * 0.13
                          : constraints.maxHeight / 2,
                      child: AnimatedOpacity(
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        duration: kDuration,
                        child: DoorLock(
                          isLock: _controller.isFrontDoorLocked,
                          press: _controller.updateFrontDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: kDuration,
                      bottom: _controller.selectedBottomTab == 0
                          ? constraints.maxHeight * 0.17
                          : constraints.maxHeight / 2,
                      child: AnimatedOpacity(
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        duration: kDuration,
                        child: DoorLock(
                          isLock: _controller.isTrunkDoorLocked,
                          press: _controller.updateTrunkDoorLock,
                        ),
                      ),
                    ),

                    //Battery tab from here on out
                    Opacity(
                      opacity: _animationBattery.value,
                      child: SvgPicture.asset("assets/icons/Battery.svg", width: constraints.maxWidth * 0.45),
                    ),
                    Positioned(
                      top: 50 * (1 - _animationBatteryStatus.value),
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Opacity(
                        opacity: _animationBatteryStatus.value,
                        child: BatteryStatus(constraints: constraints),
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        );
      }
    );
  }
}