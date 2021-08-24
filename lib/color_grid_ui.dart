import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_data.dart';
import 'general_utils.dart';

class ColorGrid extends StatelessWidget {
  const ColorGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).size.width / 12; // This line seems to help in resizing widgets on width or height change properly.
    return Center(
      child: Table(
        children: [
          TableRow(
            children: [for (var i = 0; i < 10; i++) ColorCard(index: i)],
          ),
          TableRow(
            children: [for (var i = 0; i < 10; i++) SizedBox(height: Get.height / 48,)],
          ),
          TableRow(
            children: [for (var i = 10; i < 20; i++) ColorCard(index: i)],
          ),
        ],
      ),
    );
  }
}

class ColorCard extends StatelessWidget {
  final int index;
  ColorCard({Key? key, required this.index}) : super(key: key);

  final initialElevation = Get.size.width / 144;
  var padding = Get.size.width / 12;
  var elevation = (Get.size.width / 144).obs;
  var borderRadius = (Get.size.width / 72).obs;
  var rotationAngle = 0.0.obs;
  var scale = 1.0.obs;
  var clicked = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: getColorFromRgbList(colorList[index]),
        onTap: () => handleTap(context, index),
        onHover: handleHover,
        child: Obx(
          () => Transform.scale(
            scale: scale.value,
            child: Transform.rotate(
              angle: rotationAngle.value,
              child: Card(
                borderOnForeground: false,
                child: SizedBox(
                  width: Get.width / 18,
                  height: Get.width / 18,
                ),
                elevation: elevation.value,
                color: getColorFromRgbList(colorList[index]),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius.value),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  handleHover(bool isHovered) {
    if (isHovered) {
      elevation.value = elevation.value + 20;
      scale.value = 1.1;
    } else if (!clicked) {
      elevation.value = initialElevation;
      scale.value = 1.0;
    }
  }

  void handleTap(context, index) async {
    clicked = true;
    rotationAngle.value = -0.3;
    elevation.value = elevation.value + 20;

    await applyColorScheme(context, index: index);

    rotationAngle.value = 0;
    elevation.value = initialElevation; // No matter what elevation should be restored to initial value.
    scale.value = 1.0;
    clicked = false;
  }
}
