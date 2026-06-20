import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/weather_controller.dart';
import '../widgets/weather_widgets.dart';
import '../utils/weather_utils.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  // Génère un dégradé dynamique selon le code de l'icône OpenWeather

  @override
  Widget build(BuildContext context) {
    final currentIcon =
        context.watch<WeatherController>().weather?.iconCode ?? '01d';
    final gradientColors = WeatherUtils.getBackgroundGradient(currentIcon);
    final controller = context.watch<WeatherController>();

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 1. Barre de Recherche
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Entrez une ville (ex: Abidjan, Paris)",
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withValues(
                            alpha: 0.2,
                          ), // Correct et propre,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: () {
                        if (_cityController.text.isNotEmpty) {
                          context.read<WeatherController>().fetchWeather(
                            _cityController.text,
                          );
                        }
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.search, color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 2. Historique des Recherches (Chips)
                if (context.watch<WeatherController>().searchHistory.isNotEmpty)
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.searchHistory.length,
                      itemBuilder: (context, index) {
                        final city = controller.searchHistory[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ActionChip(
                            label: Text(city),
                            backgroundColor: const Color.fromARGB(
                              255,
                              247,
                              202,
                              3,
                            ).withValues(alpha: 0.2),
                            labelStyle: const TextStyle(color: Colors.black),
                            onPressed: () {
                              _cityController.text = city.split(',')[0];
                              context.read<WeatherController>().fetchWeather(
                                _cityController.text,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 20),

                // 3. Zone d'affichage des états de l'écran
                Expanded(
                  child: Center(
                    child: () {
                      switch (controller.status) {
                        case WeatherStatus.initial:
                          return const Text(
                            "Recherchez une ville pour obtenir la météo.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                            ),
                          ).animate().fadeIn(duration: 500.ms);

                        case WeatherStatus.loading:
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );

                        case WeatherStatus.error:
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: 60,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                controller.errorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ).animate().shake(duration: 400.ms);

                        case WeatherStatus.success:
                          final weather = controller.weather!;
                          final timeFormat = DateFormat('HH:mm');

                          return SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${weather.cityName}, ${weather.country}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Image.network(
                                  "https://openweathermap.org/img/wn/${weather.iconCode}@4x.png",
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.wb_sunny,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "${weather.temperature.toStringAsFixed(1)}°C",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 64,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                Text(
                                  weather.description.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // Grille des détails techniques
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    WeatherDetailCard(
                                      icon: Icons.water_drop,
                                      label: "Humidité",
                                      value: "${weather.humidity}%",
                                    ),
                                    WeatherDetailCard(
                                      icon: Icons.air,
                                      label: "Vent",
                                      value:
                                          "${weather.windSpeed} km/h (${WeatherUtils.getWindDirection(weather.windSpeed)})",
                                    ),
                                    WeatherDetailCard(
                                      icon: Icons.wb_sunny_outlined,
                                      label: "Lever",
                                      value: timeFormat.format(weather.sunrise),
                                    ),
                                    WeatherDetailCard(
                                      icon: Icons.dark_mode_outlined,
                                      label: "Coucher",
                                      value: timeFormat.format(weather.sunset),
                                    ),
                                  ],
                                ),
                              ],
                            ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
                          );
                      }
                    }(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
