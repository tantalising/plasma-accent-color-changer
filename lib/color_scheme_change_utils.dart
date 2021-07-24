import 'app_data.dart';
import 'color_scheme_parse_utils.dart';
import 'general_utils.dart';
import 'typedefs.dart';
import 'dart:io';
import 'color_scheme_read_and_write_utils.dart';

Future<ParsedColorScheme> generateColorScheme(
    List<String> colorFieldValueAsRgbList,
    {Function? onFileReadFailure}) async {

  var themePath = await  getCurrentlySetThemePath();
  var parsedColorScheme = await  readAndParseColorScheme(themePath);

  try {
    sectionToContentMap.keys.forEach((section) {
      var currentSectionToChange = parsedColorScheme[section];
      var colorFieldsForCurrentSection = sectionToContentMap[section];

      setColorForSection(colorFieldsForCurrentSection, currentSectionToChange,
          colorFieldValueAsRgbList);
    });

  } catch (e) {
    if (onFileReadFailure != null) {
      onFileReadFailure();
    }
  }

  return parsedColorScheme;
}

Future<void> setColorScheme(ParsedColorScheme colorSchemeToWrite,
    {Function? onFileWriteFailure}) async {
  try {

    var themePathList = await  getThemePathsToWrite(); // must be of length 2
    for (var i=0; i < 2; i++) {
      var themePath = themePathList[i];
      setColorFieldsNeedingDifferentValue(colorSchemeToWrite, colorSchemeNamesForGeneralSection[i]);
      var colorSchemeAsString = getColorSchemeAsString(colorSchemeToWrite);

      var colorSchemeFile = File(themePath);
      await colorSchemeFile.writeAsString(colorSchemeAsString);
    }
  } catch (e) {
    if (onFileWriteFailure != null) {
      onFileWriteFailure();
    }

    stderr.write('Write error');
  }
}

String getColorSchemeAsString(ParsedColorScheme parsedColorScheme) {
      var colorSchemeLinesList = convertToColorSchemeLinesList(parsedColorScheme);
      var colorScheme = colorSchemeLinesList.join('\n');
      var colorSchemeAsString = removeDuplicateNewlines(colorScheme);
      return colorSchemeAsString;
}

Future<void> changeSystemColorScheme({Function? onChangeColorFailure}) async {
  try {
    var setColorSchemeProcess = await Process.run(
        'sh',
        [
          '-c',
          'plasma-apply-colorscheme ${colorSchemeNamesSuitableForApplyingByNativeCommand[0]}; plasma-apply-colorscheme ${colorSchemeNamesSuitableForApplyingByNativeCommand[1]}'
        ],
        runInShell: true,
        includeParentEnvironment: true);

    stdout.write(setColorSchemeProcess.stdout);
    stderr.write(setColorSchemeProcess.stderr);
  } catch (e) {
    if (onChangeColorFailure != null) {
      onChangeColorFailure();
    }
    stderr.write("Error! Can't apply the theme!");
  }
}