import 'package:flutter/material.dart';

class PizzaDeliveryInput extends TextFormField {
  PizzaDeliveryInput(
    label, {
    TextEditingController controller,
    TextInputType keyboardType,
    FormFieldValidator validator,
    Icon suffixIcon,
    Function suffixIconOnPressed,
    obscureText = false,
  }) : super(
            keyboardType: keyboardType,
            validator: validator,
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: suffixIcon,
                      onPressed: suffixIconOnPressed,
                    )
                  : null,
            ));
}
