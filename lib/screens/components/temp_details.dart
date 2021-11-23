import 'package:flutter/material.dart';
import 'package:gigi_control_app/screens/components/temp_button.dart';

import '../../constants.dart';
import '../../home_controller.dart';

class TempDetails extends StatelessWidget {
  const TempDetails({
    Key? key,
    required HomeController controller,
  }) : _controller = controller, super(key: key);

  final HomeController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: Row(
              children: [
                TempButton(
                  isActive: _controller.isCoolSelected,
                  svgSrc: "assets/icons/coolShape.svg",
                  title: "Cool",
                  press: _controller.updateCoolSelectedTab,
                ),
                const SizedBox(width: kPadding),
                TempButton(
                  isActive: !_controller.isCoolSelected,
                  svgSrc: "assets/icons/heatShape.svg",
                  title: "Heat",
                  activeColor: kRedColor,
                  press: _controller.updateCoolSelectedTab,
                ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: const Icon(Icons.arrow_drop_up, size: 48),
              ),
              const Text(
                "29" "\u2103",
                style: TextStyle(
                  fontSize: 86,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: const Icon(Icons.arrow_drop_down, size: 48),
              ),
            ],
          ),
          const Spacer(),
          Text("Current Temperature".toUpperCase()),
          const SizedBox(height: kPadding),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Inside".toUpperCase()),
                  Text(
                    "20" "\u2103",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              const SizedBox(width: kPadding),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Outside".toUpperCase(),
                    style: const TextStyle(color: Colors.white54),
                  ),
                  Text(
                    "35" "\u2103",
                    style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}