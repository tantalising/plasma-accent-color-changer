import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'adaptive_colorscheme_change_utils.dart';
import 'card_button_ui.dart';
import 'color_area_ui.dart';
import 'general_utils.dart';

class ButtonArea extends StatelessWidget {
  const ButtonArea({
    Key? key,
    required this.wallpaperColorPickerButtonText,
    required this.isWallpaperButtonDisabled,
    required this.colorPickerButtonText,
    required this.isColorPickerButtonDisabled,
  }) : super(key: key);

  final RxString wallpaperColorPickerButtonText;
  final RxBool isWallpaperButtonDisabled;
  final RxString colorPickerButtonText;
  final RxBool isColorPickerButtonDisabled;

  @override
  Widget build(BuildContext context) {
    return ColorArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 1,
            child: CardButton(
              text: wallpaperColorPickerButtonText,
              isDisabled: isWallpaperButtonDisabled,
              onPressed: () => setWallpaperColor(context),
            ),
          ),
          SizedBox(
            width: Get.width / 36,
          ),
          Flexible(
            flex: 1,
            child: CardButton(
              text: colorPickerButtonText,
              isDisabled: isColorPickerButtonDisabled,
              onPressed: () => pickAndChangeAccentColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickAndChangeAccentColor(BuildContext context) async {
    final Color newColor = await showColorPickerDialog(
      context,
      Colors.transparent,
      title: Text(
        'ColorPicker',
        style: Theme.of(context).textTheme.headline6,
      ),
      width: 40,
      height: 40,
      spacing: 0,
      runSpacing: 0,
      borderRadius: 0,
      wheelDiameter: 165,
      enableOpacity: true,
      showColorCode: true,
      colorCodeHasColor: true,
      pickersEnabled: <ColorPickerType, bool>{
        ColorPickerType.wheel: true,
      },
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        copyButton: true,
        pasteButton: true,
        longPressMenu: true,
      ),
      actionButtons: const ColorPickerActionButtons(
        okButton: true,
        closeButton: true,
        dialogActionButtons: false,
      ),
      constraints: BoxConstraints(
          minHeight: Get.height * 0.6,
          minWidth: Get.width * 0.6,
          maxWidth: Get.width),
    );

    await setColorFromColorPicker(context, newColor);
  }

  Future<void> setColorFromColorPicker(
      BuildContext context, Color newColor) async {
    if (newColor != Colors.transparent) {
      colorPickerButtonText.value = 'Setting Color...';
      isColorPickerButtonDisabled.value = true;

      var color = colorAsRgbStringList(newColor);
      await applyColorScheme(context, color: color);

      isColorPickerButtonDisabled.value = false;
      colorPickerButtonText.value = 'Choose A Custom Color';
    }
  }

  Future<void> setWallpaperColor(context) async {
    wallpaperColorPickerButtonText.value = 'Setting Color...';
    isWallpaperButtonDisabled.value = true;
    var color = await getDominantWallpaperColor(
      onDominantColorGenerationFailure: () => showFailureMessage(
        context: context,
        message: 'Failed to set dominant wallpaper color',
      ),
    );
    await applyColorScheme(context, color: color);
    isWallpaperButtonDisabled.value = false;
    wallpaperColorPickerButtonText.value = 'Set The Dominant Wallpaper Color';
  }
}
