import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {

  final Key key;
  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  CustomElevatedButton({
    this.key,
    this.child,
    this.color,
    this.borderRadius: 2.0,
    this.height: 50.0,
    this.onPressed,
  }) : assert(borderRadius != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(this.color),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
          )),
        ),
        child: this.child,
        onPressed: this.onPressed,
      ),
    );
  }
}
