
enum Gender {
  Male,
  Female,
}

class User {
  String userName;
  String password;
  String email;
  Gender gender;

  User({
    required this.userName,
    required this.password,
    required this.email,
    required this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['userName'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
      gender: _parseGender(json['gender'] as String), // Parse the gender value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
      'email': email,
      'gender': _genderToString(gender), // Convert gender to a string
    };
  }

  static Gender _parseGender(String value) {
    switch (value.toUpperCase()) {
      case 'MALE':
        return Gender.Male;
      case 'FEMALE':
        return Gender.Female;
      default:
        return Gender
            .Male; // Return a default value when the value is not recognized
    }
  }

  static String _genderToString(Gender gender) {
    return gender == Gender.Male
        ? 'MALE'
        : 'FEMALE'; // Convert gender to uppercase string
  }
}
