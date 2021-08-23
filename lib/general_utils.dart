import 'dart:ui';
import 'package:desktop_linux/color_scheme_read_and_write_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_data.dart';
import 'color_scheme_change_utils.dart';
import 'typedefs.dart';
import 'dart:io';

ColorSchemeSection getSectionValueMap(
    int lineNumber, List<String> colorSchemeLines) {
  ColorSchemeSection sectionValueMap = {};
  lineNumber++;
  if (lineNumber >= colorSchemeLines.length) {
    return sectionValueMap;
  }

  try {
    var notReachedToNextSection = !colorSchemeLines[lineNumber].contains('[');

    while (notReachedToNextSection) {
      var currentLine = colorSchemeLines[lineNumber];
      var equalCharPosition = currentLine.indexOf('=');

      if (equalCharPosition >= 0) {
        var subStringBeforeEqualChar =
            currentLine.substring(0, equalCharPosition);
        var subStringAfterEqualCharAsList =
            currentLine.substring(equalCharPosition + 1).split(',');

        sectionValueMap[subStringBeforeEqualChar] =
            subStringAfterEqualCharAsList;
      }
      lineNumber++;
      notReachedToNextSection = !colorSchemeLines[lineNumber].contains('[');
    }
  } catch (_) {
    // Ignore it
  }
  return sectionValueMap;
}

String removeDuplicateNewlines(String colorScheme) {
  var colorSchemeLinesList = colorScheme.split('\n');
  for (var i = 0; i < colorSchemeLinesList.length - 1; i++) {
    if (colorSchemeLinesList[i].isEmpty &&
        colorSchemeLinesList[i + 1].isEmpty) {
      colorSchemeLinesList.removeAt(i);
    }
  }
  return colorSchemeLinesList.join('\n');
}

void setColorForSection(
  // In util class
  List<String>? section,
  ColorSchemeSection? sectionColorFields,
  List<String> colorFieldValueAsRgbList,
) {
  section!.forEach((colorField) {
    var colorFieldValueAsRgbListWithLessOpacity =
        getLessOpaqueRgb(colorFieldValueAsRgbList);

    if (colorField.contains('Alternate')) {
      sectionColorFields![colorField] = colorFieldValueAsRgbListWithLessOpacity;
    } else {
      sectionColorFields![colorField] = colorFieldValueAsRgbList;
    }
  });
}

List<String> getLessOpaqueRgb(List<String> colorFieldValueAsRgbList) {
  // In util class
  var rgbList = <String>[];
  colorFieldValueAsRgbList.forEach((value) {
    if (int.parse(value) >= 8) {
      rgbList.add((int.parse(value) - 8).toString());
    } else {
      rgbList.add(int.parse(value).toString());
    }
  });
  return rgbList;
}

void setColorFieldsNeedingDifferentValue(ParsedColorScheme parsedColorScheme,
    [List<String>? colorSchemeName = const ['unknown', 'Color']]) {
  // The text should be white when highlighted in dolphin and other places
  parsedColorScheme['[Colors:Selection]']!['ForegroundNormal'] = const [
    '255',
    '255',
    '255'
  ];

  parsedColorScheme['[General]']!['ColorScheme'] = [colorSchemeName!.join()];
  parsedColorScheme['[General]']!['Name'] = [colorSchemeName.join(' ')];
}

Color getColorFromRgbList(List<String> rgbList) {
  var red = int.parse(rgbList[0]);
  var green = int.parse(rgbList[1]);
  var blue = int.parse(rgbList[2]);
  var opacity = 1.0;

  return Color.fromRGBO(red, green, blue, opacity);
}

void showFailureMessage({required String message, required context}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Color Scheme Changer'),
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).errorColor),
      ),
      actions: [
        TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.green),
            ))
      ],
    ),
  );
}

Future<void> applyColorScheme(BuildContext context,
    {List<String>? color, int? index}) async {
  bool encounteredWriteError = false;

  var colorSchemeToWrite =
      await generateColorScheme(color ?? colorList[index ?? 0],
          onFileReadFailure: () => alreadyTriedToApplyColorscheme
              ? showFailureMessage(
                  message: "Failed to read color current color scheme.",
                  context: context,
                )
              : print("") //ignore error for first run,
          );
  await setColorScheme(
    colorSchemeToWrite,
    onFileWriteFailure: () => alreadyTriedToApplyColorscheme
        ? showFailureMessage(
            message: "Failed to write new color scheme.",
            context: context,
          )
        : () { //else
            removeGeneratedThemeFiles();
            encounteredWriteError = true;
            applyColorScheme(context, color: color, index: index);
          }(), // Try to avoid error for first time and try again
  );

  if (!encounteredWriteError) {
    await changeSystemColorScheme(
      onChangeColorFailure: () => showFailureMessage(
        message: "Failed to change color scheme.",
        context: context,
      ),
    );
  }

  alreadyTriedToApplyColorscheme = true;
}

List<String> colorAsRgbStringList(Color materialColor) {
  var color = [
    materialColor.red.toString(),
    materialColor.green.toString(),
    materialColor.blue.toString()
  ];
  return color;
}

void removeGeneratedThemeFiles() async {
  String homeDir = await getHomeDir();
  List<File> fileListToBeDeleted = [
    File("$homeDir/.local/share/color-schemes/${colorSchemeNamesToWriteTo[0]}"),
    File("$homeDir/.local/share/color-schemes/${colorSchemeNamesToWriteTo[1]}"),
  ];

  try {
    for (var file in fileListToBeDeleted) {
      await file.delete();
    }
  } catch (e) {
    print(
        "can't delete file. The error is $e. Try manually deleting generaterated"
        "theme files in ~/.local/share/color-schemes/ and try again.");
  }
}
