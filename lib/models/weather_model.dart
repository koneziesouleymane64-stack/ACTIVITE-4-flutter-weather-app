class WeatherModel {
  final double temperature;
  final String description;
  final String cityName;
  final double feelsLike;
  final String country;
  final double tempMin;
  final double tempMax;
  final double windSpeed;
  final int windDegree;
  final int humidity;
  final int pressure;
  final String iconCode;
  final DateTime sunrise;
  final DateTime sunset;
  final int visibility;

  const WeatherModel({
    required this.temperature,
    required this.description,
    required this.cityName,
    required this.feelsLike,
    required this.country,
    required this.tempMin,
    required this.tempMax,
    required this.windSpeed,
    required this.windDegree,
    required this.humidity,
    required this.pressure,
    required this.iconCode,
    required this.sunrise,
    required this.sunset,
    required this.visibility,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      cityName: json['name'] as String,
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      country: json['sys']['country'] as String,
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDegree: json['wind']['deg'] as int,
      humidity: json['main']['humidity'] as int,
      pressure: json['main']['pressure'] as int,
      iconCode: json['weather'][0]['icon'] as String,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        json['sys']['sunrise'] * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
      visibility: json['visibility'] as int,
    );
  }
}
