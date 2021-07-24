import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToggleButton extends StatefulWidget {
  final Function onToggleOn;
  final Function onToggleOff;
  final double? buttonSize;
  final RxBool isToggled;

  ToggleButton({
    Key? key,
    required this.onToggleOn,
    required this.onToggleOff,
    required this.isToggled,
    this.buttonSize,
  }) : super(key: key);

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    double size = widget.buttonSize ?? MediaQuery.of(context).size.width / 24;

    return Obx(
      () => Container(
        alignment: Alignment.topRight,
        child: InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: !widget.isToggled.value
              ? Icon(
                  Icons.toggle_off_outlined,
                  size: size,
                )
              : Icon(
                  Icons.toggle_on,
                  size: size,
                ),
          onTap: onPressed,
        ),
      ),
    );
  }

  void onPressed() async {
    if (widget.isToggled.value) {
      widget.onToggleOff();
    } else {
      widget.onToggleOn();
    }
  }
}
