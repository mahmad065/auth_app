enum Gender {
  male,
  female,
}

class UserModel {
  UserModel({
    required this.name,
    required this.email,
    required this.gender,
    required this.number,
  });

  String name;
  String email;
  String number;
  Gender gender;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'gender': gender.name,
      'number': number,
    };
  }
}
