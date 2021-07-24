
import 'package:desktop_linux/section_title_ui.dart';
import 'package:desktop_linux/wallpaper_color_picker_modes_ui.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'button_area_ui.dart';
import 'color_area_ui.dart';
import 'header_area_ui.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.setMinWindowSize(Size(Get.width * 0.70, Get.width * 0.62));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var wallpaperColorPickerButtonText = 'Set The Dominant Wallpaper Color'.obs;
  var colorPickerButtonText = 'Choose A Custom Color'.obs;
  var isWallpaperButtonDisabled = false.obs;
  var isColorPickerButtonDisabled = false.obs;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            Column(
            children: [
              const HeaderBar(),
              const ColorArea(),
              const SectionTitle(
                  title: 'Choose Color Implicitly',
              ),
               ButtonArea(
                wallpaperColorPickerButtonText: wallpaperColorPickerButtonText,
                isWallpaperButtonDisabled: isWallpaperButtonDisabled,
                colorPickerButtonText: colorPickerButtonText,
                 isColorPickerButtonDisabled: isColorPickerButtonDisabled,
              ),
              const SectionTitle(title: 'Choose Wallpaper Color Type'),
              const ColorPickerModes(),
            ],
          ),],
        ),
      ),
    );
  }
}

