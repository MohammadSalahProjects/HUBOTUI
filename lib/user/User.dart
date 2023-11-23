enum Gender { male, female }

class User {
  String id;
  String userName;
  String password;
  // String email; // Uncomment if needed
  // Gender gender; // Uncomment if needed
  DateTime dob;

  User({
    required this.id,
    required this.userName,
    required this.password,
    required this.dob,
    // this.email, // Uncomment if needed
    // this.gender, // Uncomment if needed
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      password: json['password'],
      dob: DateTime.parse(json['dob']),
      // email: json['email'], // Uncomment if needed
      // gender: json['gender'] == 'male' ? Gender.male : Gender.female, // Uncomment if needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'password': password,
      'dob': dob.toIso8601String(),
      // 'email': email, // Uncomment if needed
      // 'gender': gender == Gender.male ? 'male' : 'female', // Uncomment if needed
    };
  }
}
