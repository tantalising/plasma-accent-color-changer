import 'dart:io';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'app_data.dart';
import 'current_wallpaper_read_utils.dart';
import 'general_utils.dart';

Future<List<String>> getDominantWallpaperColor(
    {Function? onDominantColorGenerationFailure}) async {
  List<String> color = [];
  try {
    var wallpaperPath = await getCurrentWallpaperPath();
    var wallpaperImage = Image.file(File(wallpaperPath));
    var dominantColorPalette =
        await PaletteGenerator.fromImageProvider(wallpaperImage.image);

    Color materialColor = getWallpaperColor(dominantColorPalette);

    color = colorAsRgbStringList(materialColor);
  } catch (e) {
    stdout.write("Can't generate adaptive color scheme. The error is $e");
    if (onDominantColorGenerationFailure != null) {
      onDominantColorGenerationFailure();
    }
  }
  return color;
}


Color getWallpaperColor(PaletteGenerator dominantColorPalette) {
  Color materialColor;
  switch (pickedWallpaperColorMode.value) {
    case 'dominant':
      materialColor = dominantColorPalette.dominantColor!.color;
      break;
    case 'vibrant':
      materialColor = dominantColorPalette.vibrantColor!.color;
      break;
  
    case 'muted':
      materialColor = dominantColorPalette.mutedColor!.color;
      break;
  
    case 'light_vibrant':
      materialColor = dominantColorPalette.lightVibrantColor!.color;
      break;
  
    case 'dark_vibrant':
      materialColor = dominantColorPalette.darkVibrantColor!.color;
      break;
  
    case 'light_muted':
      materialColor = dominantColorPalette.lightMutedColor!.color;
      break;
  
    case 'dark_muted':
      materialColor = dominantColorPalette.darkMutedColor!.color;
      break;
      
    default:
      materialColor = dominantColorPalette.dominantColor!.color;
      break;
  }
  return materialColor;
}
