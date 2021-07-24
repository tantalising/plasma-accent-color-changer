import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_data.dart';
import 'color_grid_ui.dart';

class ColorArea extends StatelessWidget {
  final Widget? child;
  const ColorArea({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: Get.width / 60, right: Get.width / 60,),
      child: Obx(
        () => Card(
          child: Column(
            children: [
              Container(
                child:Center(child: child ?? const ColorGrid()),
                padding: EdgeInsets.all(Get.width / 60),
              ),
            ],
          ),
          color: isDarkModeOn.value
              ? ThemeData.dark().secondaryHeaderColor
              : ThemeData.light().secondaryHeaderColor,
        ),
      ),
    );
  }
}
