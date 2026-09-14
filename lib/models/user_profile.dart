class UserProfile {
  String id;
  String name;
  String email;
  String phone;
  String profession;
  String country;
  String city;

  UserProfile({
    required this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.profession = 'Architect',
    this.country = '',
    this.city = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profession': profession,
      'country': country,
      'city': city,
    };
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserProfile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      profession:
          json['profession'] as String? ?? 'Architect',
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
    );
  }
}