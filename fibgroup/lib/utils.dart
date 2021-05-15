import 'package:flutter/material.dart';

class Popup {
  static Future<void> fancyPopup(
      {@required BuildContext context,
      @required List<Widget> children,
      CrossAxisAlignment columnCrossAlignment = CrossAxisAlignment.center,
      bool barrierDismissible = true}) {
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 25, right: 25, bottom: 150),
          child: Center(
            child: Material(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 7),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: columnCrossAlignment,
                    children: children),
              ),
            ),
          ),
        );
      },
      barrierDismissible: barrierDismissible,
    );
  }
}
