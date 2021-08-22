import 'package:get/get.dart';

var sectionToContentMap =  const <String, List<String>>{
    '[Colors:Selection]': [
      'ForegroundActive',
      'BackgroundNormal',
      'BackgroundAlternate',
      'DecorationFocus',
      'DecorationHover'
    ],

    '[Colors:Button]' : [
      'ForegroundActive',
      'DecorationFocus',
      'DecorationHover'
    ],

    '[Colors:Tooltip]' : [
      'DecorationHover'
    ],

    '[Colors:View]' : [
      // 'BackgroundAlternate', this looks bad if changed.
      'DecorationFocus',
      'DecorationHover'
    ],

  };

var colorList = [
  ["244", "67", "54"],
  ["233", "30", "99"],
  ["156", "39", "176"],
  ["103", "58", "183"],
  ["63", "81", "181"],
  ["33", "150", "243"],
  ["3", "169", "244"],
  ["0", "188", "212"],
  ["0", "150", "136"],
  ["76", "175", "80"],
  ["139", "195", "74"],
  ["205", "220", "57"],
  ["255", "235", "59"],
  ["255", "193", "7"],
  ["255", "152", "0"],
  ["255", "87", "34"],
  ["121", "85", "72"],
  ["158", "158", "158"],
  ["96", "125", "139"],
  ["136", "14", "79"],
];

var wallpaperColorPickerModeMap = const <String, String>{
  'Dominant Color'        :       'dominant',
  'Vibrant Color'         :       'vibrant',
  'Muted Color'           :       'muted',
  'Dark Vibrant Color'    :       'dark_vibrant',
  'Light Vibrant Color'   :       'light_vibrant',
  'Dark Muted Color'      :       'dark_muted',
  'Light Muted Color'     :       'light_muted',
};

// Since plasma-apply-colorscheme doesn't set the same theme again, we need two theme files with same content.
// We will set both themes one after one and one will for sure be set.
List<String> colorSchemeNamesToWriteTo = const ['variableColor.colors', 'variableColors.colors'];

// The native command is plasma-apply-colorscheme
List<String> colorSchemeNamesSuitableForApplyingByNativeCommand = const ['variableColors', 'variableColor'];

// Color scheme names for putting into the general field. They are in this format for ease of writing operation.
// We will write them first by joining them and later we will also have to write them with a space between.
List<List<String>> colorSchemeNamesForGeneralSection = const [['variable', 'Colors'], ['variable', 'Color']];

String wallpaperPluginMode = 'org.kde.image';

String wallpaperSectionName = '[Containments][1][Wallpaper][org.kde.image][General]';

RxBool isDarkModeOn = false.obs;
RxString pickedWallpaperColorMode = 'dominant'.obs;

bool alreadyTriedToApplyColorscheme = false;
