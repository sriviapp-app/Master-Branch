import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class FluidCarousel extends StatelessWidget {
  final List<Widget> children;
  final Function(int)? onPageChanged;
  final LiquidController controller;

  const FluidCarousel({
    super.key,
    required this.children,
    required this.controller,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidSwipe(
      pages: children,
      fullTransitionValue: 100,
      enableLoop: false,
      waveType: WaveType.liquidReveal,
     // slideIconWidget: const Icon(Icons.arrow_back_ios, color: Colors.white),
      positionSlideIcon: 0.8,
      onPageChangeCallback: onPageChanged,
      liquidController: controller,
    );
  }
}

