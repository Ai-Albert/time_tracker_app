import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    @required String image,
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed
  }) : assert(text != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset('images/$image'),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15.0,
                ),
              ),
              Opacity(
                child: Image.asset('images/$image'),
                opacity: 0.0,
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}