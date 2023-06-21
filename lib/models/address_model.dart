import 'dart:convert';

class Address {
  final String street;
  final String city;
  final String state;
  final String postalCode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'],
      city: map['city'],
      state: map['state'],
      postalCode: map['postalCode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String jsonStr) =>
      Address.fromMap(json.decode(jsonStr));
}
