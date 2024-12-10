class City {
  final String name;
  final String lat;
  final String lng;
  final String country;
  final String admin1;
  final String admin2;

  City({
    required this.name,
    required this.lat,
    required this.lng,
    required this.country,
    required this.admin1,
    required this.admin2,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      lat: json['lat'],
      lng: json['lng'],
      country: json['country'],
      admin1: json['admin1'],
      admin2: json['admin2'],
    );
  }
}
