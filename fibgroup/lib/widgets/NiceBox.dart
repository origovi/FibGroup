import 'package:flutter/material.dart';

class NiceBox extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color color;
  final EdgeInsets padding;
  final void Function() onTap;
  final void Function() onLongPress;
  final void Function(TapDownDetails) onTapDown;

  NiceBox({
    this.child,
    this.radius = 10,
    this.onTap,
    this.onLongPress,
    this.onTapDown,
    this.color = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: InkWell(
        onTapDown: onTapDown,
        onLongPress: onLongPress,
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}