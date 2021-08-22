import 'dart:io';
import 'app_data.dart';
import 'color_scheme_parse_utils.dart';
import 'typedefs.dart';

Future<List<String>> getThemePathsToWrite() async {
  var homeDir = await getHomeDir();
  var themeDir = homeDir + '/.local/share/color-schemes';
  var themePathList = [
    '$themeDir/${colorSchemeNamesToWriteTo[0]}',
    '$themeDir/${colorSchemeNamesToWriteTo[1]}'
  ];
  await createColorSchemeFileIfnotExists(themePathList);
  return themePathList;
}

Future<String> getHomeDir() async {
  var getHomeDirProcess = await Process.run('sh', ['-c', 'echo -n \$HOME'],
      runInShell: true, includeParentEnvironment: true);

  stdout.write(getHomeDirProcess.stdout);
  stderr.write(getHomeDirProcess.stderr);

  return getHomeDirProcess.stdout;
}

Future<void> createColorSchemeFileIfnotExists(
    List<String> themePathList) async {
  themePathList.forEach((themePath) async {
    var themeFileExists = await File(themePath).exists();
    if (!themeFileExists) {
      await File(themePath).create(recursive: true);
    }
  });
}

Future<String> getCurrentlySetThemePath() async {
  var possibleColorSchemePathList = await getPossibleColorSchemePathList();

  for (var colorSchemePath in possibleColorSchemePathList) {
    var colorSchemeExists = await File(colorSchemePath).exists();
    if (colorSchemeExists) {
      return colorSchemePath;
    }
  }
  throw ("Error! Didn't find the color scheme!");
}

Future<List<String>> getPossibleColorSchemePathList() async {
  var currentColorSchemeName = await getCurrentColorSchemeName();
  var possibleColorSchemePathList = <String>[
    '/usr/share/color-schemes/$currentColorSchemeName.colors'
  ];
  var homeDir = await getHomeDir();
  var localPath =
      homeDir + '/.local/share/color-schemes/$currentColorSchemeName.colors';

  possibleColorSchemePathList.add(localPath);

  return possibleColorSchemePathList;
}

Future<String> getCurrentColorSchemeName() async {
  var getCurrentColorSchemeProcess = await Process.run(
      'sh',
      [
        '-c',
        "LANG=C; plasma-apply-colorscheme  --list-schemes | grep current | cut -c 1-3 --complement | sed 's/(current color scheme)//' | xargs echo -n"
      ],
      runInShell: true,
      includeParentEnvironment: true);

  stdout.write(getCurrentColorSchemeProcess.stdout);
  stderr.write(getCurrentColorSchemeProcess.stderr);

  return getCurrentColorSchemeProcess.stdout;
}

Future<ParsedColorScheme> readAndParseColorScheme(
    String colorSchemePath) async {
  var colorSchemeFile = File(colorSchemePath);
  var colorSchemeLinesList = await colorSchemeFile.readAsLines();
  return parseColorScheme(colorSchemeLinesList);
}
