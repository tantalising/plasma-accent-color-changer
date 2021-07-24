import 'package:desktop_linux/toggle_button_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'app_data.dart';


import 'menu_item_ui.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: const Icon(Icons.menu),
        offset: Offset(-Get.width / 180, Get.width / 36),
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              child: MenuItemDarkMode(),
            ),
            PopupMenuItem(
              child: MenuItem(
                text: 'About',
                onPressed: () => PackageInfo.fromPlatform().then(
                  (PackageInfo packageInfo) {
                    showAboutDialog(
                      context: context,
                      applicationName: packageInfo.appName.split('_').join(' '),
                      applicationVersion: packageInfo.version,
                      applicationLegalese:
                          "© ${DateTime.now().year} Tanbir Jishan. All Rights Reserved.",
                    );
                  },
                ),
              ),
            ),
          ];
        });
  }
}

class Controller extends GetxController {}

class MenuItemDarkMode extends StatelessWidget {
  late final MenuItem menuItem;
  MenuItemDarkMode({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    menuItem = MenuItem(
      text: 'Dark Mode',
      trailing: ToggleButton(
        buttonSize: Get.theme.buttonTheme.minWidth * 0.6,
        onToggleOff: onToggleOff,
        onToggleOn: onToggleOn,
        isToggled: isDarkModeOn,
      ),
    );
    return menuItem;
  }

  onToggleOff() {
    Get.changeThemeMode(ThemeMode.light);
    isDarkModeOn.value = !isDarkModeOn.value;
    Get.back();
  }

  onToggleOn() {
    Get.changeThemeMode(ThemeMode.dark);
    isDarkModeOn.value = !isDarkModeOn.value;
    Get.back();
  }
}
