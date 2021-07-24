import 'general_utils.dart';
import 'typedefs.dart';

ParsedColorScheme parseColorScheme(
    // In parser class
    List<String> colorSchemeLines) {
  ParsedColorScheme parsedScheme = {};
  var lineNumber = 0;
  for (var line in colorSchemeLines) {
    var isASection = line.contains('[');
    if (isASection) {
      var sectionName = line;
      parsedScheme.putIfAbsent(
          sectionName, () => getSectionValueMap(lineNumber, colorSchemeLines));
    }
    lineNumber++;
  }
  return parsedScheme;
}

List<String> convertToColorSchemeLinesList(
    // In parser class
    ParsedColorScheme parsedColorScheme) {
  var colorSchemeLinesList = <String>[];
  parsedColorScheme.keys.forEach((section) {
    colorSchemeLinesList.add(section);
    parsedColorScheme[section]!.keys.forEach((colorField) {
      var colorName = colorField;
      var colorValue = parsedColorScheme[section]![colorField]!.join(',');
      var line = colorName + '=' + colorValue;

      colorSchemeLinesList.add(line);
    });
    colorSchemeLinesList.add(('\n'));
  });
  return colorSchemeLinesList;
}
