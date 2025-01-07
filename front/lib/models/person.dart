class Person {
  final String name;
  final String gender;
  final String family;

  Person({
    required this.name,
    required this.gender,
    required this.family,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] as String,
      gender: json['gender'] as String,
      family: json['family'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'family': family,
    };
  }
}