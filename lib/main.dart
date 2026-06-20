import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/weather_controller.dart';
import 'views/weather_view.dart';

void main() {
  // Assure les liaisons de l'architecture Flutter avant l'exécution
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherController(),
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Météo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      home: const WeatherView(),
    );
  }
}
