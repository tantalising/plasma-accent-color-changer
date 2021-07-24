import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardButton extends StatelessWidget {
  final RxString text;
  RxBool? isDisabled;
  final void Function() onPressed;
   CardButton(
      {Key? key, required this.text, required this.onPressed, this.isDisabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    isDisabled ??= false.obs;
    return SizedBox(
      height: Get.width / 24,
      width: Get.width / 3,
      child: Obx(() => ElevatedButton(
        onPressed: isDisabled!.value == false ?  onPressed : null,
        child: Text(
          text.value,
          style: TextStyle(fontSize: Get.theme.textTheme.subtitle1!.fontSize! * 1.2),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Get.size.width / 72),
            ),
          ),
        ),
      ),),
    );
  }
}
