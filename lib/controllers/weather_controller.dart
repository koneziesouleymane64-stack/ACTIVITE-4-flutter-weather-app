import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

// Définition des différents états possibles de l'écran
enum WeatherStatus { initial, loading, success, error }

class WeatherController extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  // Variables d'état privées
  WeatherStatus _status = WeatherStatus.initial;
  WeatherModel? _weather;
  String _errorMessage = '';
  final List<String> _searchHistory = [];

  // Getters publics pour protéger l'encapsulation (la vue lit mais ne modifie pas directement)
  WeatherStatus get status => _status;
  WeatherModel? get weather => _weather;
  String get errorMessage => _errorMessage;
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  // Méthode principale pour récupérer la météo
  Future<void> fetchWeather(String cityName) async {
    if (cityName.trim().isEmpty) return;

    _status = WeatherStatus.loading;
    _errorMessage = '';
    notifyListeners(); // Met à jour l'UI pour afficher le loader

    try {
      final result = await _weatherService.fetchWeatherByCity(cityName.trim());
      _weather = result;
      _status = WeatherStatus.success;

      // Gestion intelligente de l'historique de recherche
      final formattedName = "${result.cityName}, ${result.country}";
      _addToHistory(formattedName);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = WeatherStatus.error;
    } finally {
      notifyListeners(); // Rafraîchit définitivement l'UI (Succès ou Éreur)
    }
  }

  void _addToHistory(String cityName) {
    // Éviter les doublons dans l'historique
    _searchHistory.removeWhere(
      (item) => item.toLowerCase() == cityName.toLowerCase(),
    );
    // Insérer en première position
    _searchHistory.insert(0, cityName);
    // Limiter strictement à 5 éléments max
    if (_searchHistory.length > 5) {
      _searchHistory.removeLast();
    }
  }

  void clearHistory() {
    _searchHistory.clear();
    notifyListeners();
  }
}
