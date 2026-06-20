import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import 'dart:convert';

class WeatherService {
  final String _apiKey =
      '914a69c4953c73f85bbd0704caa63fe5'; // Remplacez par votre clé API OpenWeatherMap
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> fetchWeatherByCity(String cityName) async {
    final url = Uri.parse(
      '$_baseUrl?q=$cityName&appid=$_apiKey&units=metric&lang=fr',
    );

    try {
      final response = await http.get(url);

      switch (response.statusCode) {
        case 200:
          final Map<String, dynamic> data = json.decode(response.body);
          return WeatherModel.fromJson(data);
        case 401:
          throw Exception(
            'Clé API invalide. Veuillez vérifier votre configuration.',
          );
        case 404:
          throw Exception('Ville introuvable. Vérifiez l\'orthographe.');
        case 429:
          throw Exception('Limite de requêtes atteinte. Réessayez plus tard.');
        default:
          throw Exception(
            'Une erreur serveur est survenue (Code: ${response.statusCode}).',
          );
      }
    } catch (e) {
      // Capture les erreurs d'absence de connexion Internet ou de timeout
      throw Exception(
        'Impossible de contacter le serveur. Vérifiez votre connexion Internet.',
      );
    }
  }
}
