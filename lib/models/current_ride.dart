class CurrentRide {
  final String passenger;
  final String pickupLocation;
  final String destination;

  CurrentRide({
    required this.passenger,
    required this.pickupLocation,
    required this.destination,
  });

  factory CurrentRide.fromJson(Map<String, dynamic> json) {
    return CurrentRide(
      passenger: json['passenger'],
      pickupLocation: json['pickupLocation'],
      destination: json['destination'],
    );
  }
}
