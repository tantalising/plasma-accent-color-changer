import 'dart:io';
import 'app_data.dart';
import 'typedefs.dart';
import 'color_scheme_read_and_write_utils.dart';

Future<String> getCurrentWallpaperPath() async {
  var wallpaperConfig = await readAndParseWallpaperConfig();
  await updateWallpaperPluginMode(wallpaperConfig);
  var wallpaperPath = 'path/to/wallpaper';

  wallpaperPath = await getPathFromWallpaperConfig(wallpaperConfig);

  if (wallpaperPath.contains('file')) {
    wallpaperPath =
        wallpaperPath.substring(7); // The prefix to be removed is File://
  }

  return wallpaperPath;
}

Future<ParsedConfig> readAndParseWallpaperConfig() async {
  var wallpaperConfigPath = await getWallpaperConfigFilePath();
  var wallPaperConfig = await readAndParseColorScheme(wallpaperConfigPath);

  return wallPaperConfig;
}

Future<String> getPathFromWallpaperConfig(ParsedConfig wallpaperConfig) async {
  var wallpaperPath;
  // It is too much work to handle other plugins. Maybe will do later.
  if (wallpaperPluginMode != 'org.kde.slideshow' &&
      wallpaperPluginMode != 'org.kde.image') {
    // then just return any image path
    for (var section in wallpaperConfig.keys) {
      if (section.contains('org.kde.image')) {
        wallpaperPath = wallpaperConfig[section]!['Image']!
            .first; //first will get the mode(length of the list is 1) as string
      }
    }
  } else {
    await updateSectionNameOfCurrentWallpaper(wallpaperConfig);
    wallpaperPath = wallpaperConfig[wallpaperSectionName]!['Image']!.first;
  }
  return wallpaperPath;
}

Future<void> updateSectionNameOfCurrentWallpaper(
    ParsedConfig wallpaperConfig) async {
  await updateWallpaperPluginMode(wallpaperConfig);

  var highestResolution = await getHighestResolutionOfMonitors();
  var parsedWallpaperConfig = wallpaperConfig;

  parsedWallpaperConfig.forEach((section, keyValuesUnderSection) {
    parsedWallpaperConfig[section]!.forEach((sectionKey, sectionValue) {
      if (sectionKey.contains(highestResolution)) {
        wallpaperSectionName =
            '$section[Wallpaper][$wallpaperPluginMode][General]';
      }
    });
  });
}

Future<void> updateWallpaperPluginMode(ParsedConfig wallpaperConfig) async {
  var highestResolution = await getHighestResolutionOfMonitors();
  var parsedWallpaperConfig = wallpaperConfig;

  parsedWallpaperConfig.forEach((section, keyValuesUnderSection) {
    parsedWallpaperConfig[section]!.forEach((sectionKey, sectionValue) {
      if (sectionKey.contains(highestResolution)) {
        wallpaperPluginMode = parsedWallpaperConfig[section]![
                'wallpaperplugin']!
            .first; //first will get the mode(length of the list is 1) as string
      }
    });
  });
}

Future<String> getHighestResolutionOfMonitors() async {
  var resolutionList = await getResolutionListOfMonitorOrMonitors();
  resolutionList.sort();
  var highestResolution = resolutionList.last;
  return highestResolution;
}

Future<List<String>> getResolutionListOfMonitorOrMonitors(
    {Function? onGetResolutionsFailure}) async {
  var resolutionList = <String>[];
  var wallpaperConfigPath = await getWallpaperConfigFilePath();

  try {
    var getMonitorResolutions =
        await runMonitorResolutionProcess(wallpaperConfigPath);

    resolutionList = getMonitorResolutions.stdout.toString().split('\n');
  } catch (e) {
    if (onGetResolutionsFailure != null) {
      onGetResolutionsFailure();
    }
    stderr.write("Error! Can't read the resolutions!");
  }
  return resolutionList;
}

Future<String> getWallpaperConfigFilePath() async {
  var homeDir = await getHomeDir();
  var configPath = homeDir + '/.config/plasma-org.kde.plasma.desktop-appletsrc';

  return configPath;
}

Future<ProcessResult> runMonitorResolutionProcess(
    String wallpaperConfigPath) async {
  var getMonitorResolutionsProcess = await Process.run(
      'sh',
      [
        '-c',
        'cat  $wallpaperConfigPath | grep -i itemgeometries- | cut -d - -f 2 | cut -d x -f 1'
      ],
      runInShell: true,
      includeParentEnvironment: true);

  stdout.write(getMonitorResolutionsProcess.stdout);
  stderr.write(getMonitorResolutionsProcess.stderr);

  return getMonitorResolutionsProcess;
}
