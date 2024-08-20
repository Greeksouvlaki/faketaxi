// lib/models/ride_request.dart

class RideRequest {
  final int requestId;
  final int passengerId;
  final int? driverId;
  final String pickupLocation;
  final String destinationLocation;
  final String status;
  final double fareEstimate;

  RideRequest({
    required this.requestId,
    required this.passengerId,
    this.driverId,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.status,
    required this.fareEstimate,
  });

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      requestId: json['request_id'],
      passengerId: json['passenger_id'],
      driverId: json['driver_id'],
      pickupLocation: json['pickup_location'],
      destinationLocation: json['destination_location'],
      status: json['status'],
      fareEstimate: json['fare_estimate'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'passenger_id': passengerId,
      'driver_id': driverId,
      'pickup_location': pickupLocation,
      'destination_location': destinationLocation,
      'status': status,
      'fare_estimate': fareEstimate,
    };
  }
}
