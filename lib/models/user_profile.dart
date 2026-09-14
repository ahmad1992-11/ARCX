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
}