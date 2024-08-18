class Ride {
  final String startLocation;
  final String endLocation;
  final double cost;
  final String status;

  Ride({
    required this.startLocation,
    required this.endLocation,
    required this.cost,
    required this.status,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      startLocation: json['start_location'],
      endLocation: json['end_location'],
      cost: json['cost'].toDouble(),
      status: json['status'],
    );
  }
}
