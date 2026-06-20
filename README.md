# activite_acces_api

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




# Application Météo 🌤️ - Activité n°4

Application Flutter moderne permettant d'obtenir les prévisions météorologiques en temps réel via l'API OpenWeather.

## ✨ Fonctionnalités
- Recherche de météo par ville.
- Interface dynamique (dégradés de couleurs qui s'adaptent au temps qu'il fait et au cycle jour/nuit).
- Historique fluide des 5 dernières recherches (système de puces/chips cliquables).
- Affichage des données techniques : Température, Humidité, Vitesse et direction du Vent, heures de Lever/Coucher du soleil.
- Animations fluides d'apparition des données (`flutter_animate`).

## 🏗️ Architecture (MVC)
L'application respecte scrupuleusement le patron de conception **MVC** soutenu par le package **Provider** :
- `models/` : Structuration et parsing sécurisé des données JSON.
- `services/` : Logique réseau (appels HTTP et gestion robuste des codes d'erreur).
- `controllers/` : Gestion des états de l'écran (`initial`, `loading`, `success`, `error`) et des données métier via `ChangeNotifier`.
- `views/` & `widgets/` : Composants purement graphiques et interfaces d'affichage.
- `utils/` : Fonctions utilitaires de conversion (degrés du vent en texte cardinal).

## 🚀 Installation
1. Clonez le projet : `git clone <url-du-depot>`
2. Installez les dépendances : `flutter pub get`
3. Ajoutez votre clé API OpenWeather dans `lib/services/weather_service.dart`.
4. Lancez l'application : `flutter run`

