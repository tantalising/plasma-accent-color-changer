import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;
  const SectionTitle({Key? key, required this.title, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context,) {
    return Container(
      padding: padding ?? EdgeInsets.only(
          top: Get.width / 28, left: Get.width / 42, bottom: Get.width / 72),
      alignment: Alignment.topLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: Get.width / 48),
        textAlign: TextAlign.left,
      ),
    );
  }
}
