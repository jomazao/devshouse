class UserProfile {
  final String id;
  final String email;

  UserProfile({required this.id, required this.email});

  factory UserProfile.fromJson(Map map, String id)  => UserProfile(id: id, email: map['email']);

}

class EmptyUserProfile extends UserProfile{
  EmptyUserProfile() : super(id: '1', email: 'jomazao@gmail.com');
}