import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuItem extends StatefulWidget {
  final String text;
  final Widget? trailing;
  final void Function()? onPressed;

  const MenuItem({
    Key? key,
    required this.text,
    this.trailing,
    this.onPressed,
  }) : super(key: key);

  @override
  State<MenuItem> createState() {
    return _MenuItemState();
  }
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width / 120),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                widget.text,
                style: TextStyle(
                  fontSize: Get.theme.textTheme.bodyText1!.fontSize! * 1.2,
                  color: Get.theme.textTheme.bodyText1!.color,
                ),
              ),
            Container(
              child: widget.trailing,
            )
          ],
        ),
      ),
    );
  }

  void onTap() {
    if(widget.onPressed != null) {
      widget.onPressed!();
    }
  }
}
