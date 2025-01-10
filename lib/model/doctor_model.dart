class Doctor {
  final String uid;
  final String category;
  final String city;
  final String email;
  final String firstName;
  final String lastName;
  final String profileImageUrl;
  final String qualification;
  final String phoneNumber;
  final String yearsOfExperience;
  final double latitude;
  final double longitude;
  final int numberOfReviews;
  final int totalReviews;

  Doctor({
    required this.uid,
    required this.category,
    required this.city,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
    required this.qualification,
    required this.phoneNumber,
    required this.yearsOfExperience,
    required this.latitude,
    required this.longitude,
    required this.numberOfReviews,
    required this.totalReviews,
  });

  Doctor copyWith({
    String? firstName,
    String? lastName,
    String? category,
    String? city,
    String? email,
    String? profileImageUrl,
    String? qualification,
    String? phoneNumber,
    String? yearsOfExperience,
    double? latitude,
    double? longitude,
    int? numberOfReviews,
    int? totalReviews,
  }) {
    return Doctor(
      uid: this.uid,
      category: category ?? this.category,
      city: city ?? this.city,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      qualification: qualification ?? this.qualification,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }

  factory Doctor.fromMap(Map<dynamic, dynamic> map, String uid) {
    return Doctor(
      uid: uid,
      category: map['category'],
      city: map['city'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      profileImageUrl: map['profileImageUrl'],
      qualification: map['qualification'],
      phoneNumber: map['phoneNumber'],
      yearsOfExperience: map['yearsOfExperience'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      numberOfReviews: map['numberOfReviews'],
      totalReviews: map['totalReviews'],
    );
  }
}
