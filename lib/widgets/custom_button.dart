import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton(
      {required this.text,
      this.onPressed,
      this.buttonStyle,
      this.isDisabled,
      this.height,
      this.width,
      this.margin,
      this.alignment,
      this.decoration,
      this.leftIcon,
      this.rightIcon,
      this.buttonTextStyle,
      this.isSelected = false});

  final String text;

  final VoidCallback? onPressed;

  final ButtonStyle? buttonStyle;

  final TextStyle? buttonTextStyle;

  final bool? isDisabled;

  final double? height;

  final double? width;

  final EdgeInsets? margin;

  final Alignment? alignment;

  final BoxDecoration? decoration;

  final Widget? leftIcon;

  final Widget? rightIcon;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget,
          )
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
        height: height ?? 51,
        width: width ?? double.maxFinite,
        margin: margin,
        decoration: decoration,
        child: ElevatedButton(
          style: isSelected
              ? invertedButtonStyle()
              : buttonStyle ?? defaultButtonStyle(),
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon ?? const SizedBox.shrink(),
              Text(
                text,
                // style: buttonTextStyle ?? CustomTextStyles.titleMediumWhiteA700,
              ),
              rightIcon ?? const SizedBox.shrink(),
            ],
          ),
        ),
      );

  ButtonStyle defaultButtonStyle() => ElevatedButton.styleFrom();

  ButtonStyle invertedButtonStyle() => ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: const Color(0xFF6750A4));
}
