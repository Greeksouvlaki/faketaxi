// lib/models/driver.dart

class Driver {
  final int driverId;
  final int userId;
  final String vehicleType;
  final String vehicleRegistrationNumber;
  final String availabilityStatus;

  Driver({
    required this.driverId,
    required this.userId,
    required this.vehicleType,
    required this.vehicleRegistrationNumber,
    required this.availabilityStatus,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverId: json['driver_id'],
      userId: json['user_id'],
      vehicleType: json['vehicle_type'],
      vehicleRegistrationNumber: json['vehicle_registration_number'],
      availabilityStatus: json['availability_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'user_id': userId,
      'vehicle_type': vehicleType,
      'vehicle_registration_number': vehicleRegistrationNumber,
      'availability_status': availabilityStatus,
    };
  }
}
