import 'section_title_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'menu_ui.dart';


class HeaderBar extends StatelessWidget {
  const HeaderBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SectionTitle(
          title: 'Choose An Accent Color',
          padding: EdgeInsets.only(
            top: Get.width / 72,
            left: Get.width / 42,
            bottom: Get.width / 84,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: Get.width / 36,
          ),
          child: const Menu(),
        ),
      ],
    );
  }
}
