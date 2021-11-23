import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gigi_control_app/constants.dart';
import 'package:gigi_control_app/home_controller.dart';

import 'components/battery_status.dart';
import 'components/bottom_navigation_bar.dart';
import 'components/door_lock.dart';
import 'components/temp_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  late AnimationController _tempAnimationController;
  late Animation<double> _animationCarShift;
  late Animation<double> _animationTempShowInfo;
  late Animation<double> _animationCoolGlow;

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

  void setupTempAnimation() {
    _tempAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animationCarShift = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.2, 0.4),
    );

    _animationTempShowInfo = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.45, 0.65),
    );

    _animationCoolGlow = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.7, 1),
    );
  }

  @override
  void initState() {
    setupBatteryAnimation();
    setupTempAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    _tempAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _batteryAnimationController, _tempAnimationController]),
      builder: (context, _) {
        return Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(
            onTap: (index) {
              if (index == 1) {
                _batteryAnimationController.forward();
              } else if (_controller.selectedBottomTab == 1 && index != 1) {
                _batteryAnimationController.reverse(from: 0.7);
              }

              if (index == 2) {
                _tempAnimationController.forward();
              } else if (_controller.selectedBottomTab == 2 && index != 2) {
                _tempAnimationController.reverse(from: 0.4);
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
                    SizedBox(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                    ),
                    Positioned(
                      left: constraints.maxWidth / 2 * _animationCarShift.value,
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.1),
                        child: SvgPicture.asset("assets/icons/Car.svg", width: double.infinity),
                      ),
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

                    // Temperature
                    Positioned(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      top: 60 * (1 - _animationTempShowInfo.value),
                      child: Opacity(
                        opacity: _animationTempShowInfo.value,
                        child: TempDetails(
                          controller: _controller,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -180 * (1 - _animationCoolGlow.value),
                      child: AnimatedSwitcher(
                        duration: kDuration,
                        child: _controller.isCoolSelected
                            ? Image.asset(
                            "assets/images/Cool_glow_2.png",
                            key: UniqueKey(),
                            width: 200)
                            : Image.asset(
                            "assets/images/Hot_glow_4.png",
                            key: UniqueKey(),
                            width: 200
                        )
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