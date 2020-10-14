import 'package:flutter/material.dart';

class PizzaDeliveryButton extends Container {
  PizzaDeliveryButton(
    String label, {
    @required double width,
    @required double height,
    Color labelColor,
    double labelSize = 12,
    ShapeBorder shape,
    TextStyle textStyle,
    Function onPressed,
    Color buttonColor,
  }) : super(
          width: width,
          height: height,
          child: RaisedButton(
            onPressed: onPressed,
            color: buttonColor,
            child: Text(label,
                style: textStyle ??
                    TextStyle(fontSize: labelSize, color: labelColor)),
            shape: shape ??
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        );
}
