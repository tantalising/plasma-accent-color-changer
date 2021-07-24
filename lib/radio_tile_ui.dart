import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RadioTile extends StatelessWidget {
  final String text;
  final String defaultValue;
  final void Function(String? value) onClicked;
  RxString groupValue;

  RadioTile(
      {Key? key,
      required this.text,
      required this.groupValue,
      required this.defaultValue,
      required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1,
      child: ListTile(
        title: Text(
          text,
        ),
        leading: Obx(
          () => Radio<String>(
            value: defaultValue,
            groupValue: groupValue.value,
            onChanged: onClicked,
            // update the settings value here
          ),
        ),
      ),
    );
  }
}
