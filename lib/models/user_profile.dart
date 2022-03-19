class UserProfile {
  final String id;
  final String email;

  UserProfile({required this.id, required this.email});

  factory UserProfile.fromJson(Map map, String id)  => UserProfile(id: id, email: map['email']);

}