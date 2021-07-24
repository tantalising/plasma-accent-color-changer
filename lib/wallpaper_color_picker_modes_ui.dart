import 'package:desktop_linux/radio_tile_ui.dart';
import 'package:flutter/material.dart';
import 'app_data.dart';
import 'color_area_ui.dart';

class ColorPickerModes extends StatelessWidget {
  const ColorPickerModes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorModeList = <Widget>[];

    for (var key in wallpaperColorPickerModeMap.keys) {
      var tile = RadioTile(
        text: key,
        groupValue: pickedWallpaperColorMode,
        defaultValue: wallpaperColorPickerModeMap[key]!,
        onClicked: (String? value) {
          if (value != null) pickedWallpaperColorMode.value = value;
        },
      );
      colorModeList.add(tile);
    }

    return ColorArea(
      child: Table(
        children: [
          TableRow(
            children: colorModeList.sublist(0,3),
          ),
          TableRow(
            children: colorModeList.sublist(3,6),
          ),
          TableRow(
            children: [
              colorModeList[6],
              Container(),
              Container(),
            ],
          ),
        ],
      ),
    );
  }
}
