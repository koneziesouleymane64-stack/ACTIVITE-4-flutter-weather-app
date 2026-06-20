import 'package:flutter/material.dart';

class WeatherUtils {
  /// Convertit un angle en degrés (0-360) en direction cardinale textuelle
  static String getWindDirection(double degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return 'N';
    if (degrees >= 22.5 && degrees < 67.5) return 'NE';
    if (degrees >= 67.5 && degrees < 112.5) return 'E';
    if (degrees >= 112.5 && degrees < 157.5) return 'SE';
    if (degrees >= 157.5 && degrees < 202.5) return 'S';
    if (degrees >= 202.5 && degrees < 247.5) return 'SO';
    if (degrees >= 247.5 && degrees < 292.5) return 'O';
    if (degrees >= 292.5 && degrees < 337.5) return 'NO';
    return 'N/A';
  }

  /// Retourne un dégradé de couleurs adapté au code de l'icône OpenWeather
  static List<Color> getBackgroundGradient(String iconCode) {
    if (iconCode.contains('d')) {
      // Ensoleillé / Peu nuageux (Journée)
      if (iconCode.startsWith('01') || iconCode.startsWith('02')) {
        return [Colors.blue.shade400, Colors.lightBlue.shade200];
      }
      // Pluie ou Orage (Journée)
      if (iconCode.startsWith('09') ||
          iconCode.startsWith('10') ||
          iconCode.startsWith('11')) {
        return [Colors.blueGrey.shade700, Colors.indigo.shade400];
      }
    } else if (iconCode.contains('n')) {
      // Mode Nuit (Ciel clair ou nuageux)
      return [Colors.indigo.shade900, Colors.blueGrey.shade900];
    }

    // Par défaut : Nuages denses, brouillard, neige (Gris)
    return [Colors.blueGrey.shade600, Colors.grey.shade400];
  }
}
