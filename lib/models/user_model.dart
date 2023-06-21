import 'dart:convert';
import 'package:user_list/models/address_model.dart';

class User {
   String? id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  List<Address> addresses;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.addresses,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'addresses': addresses.map((address) => address.toMap()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
  List<Address> addresses = [];

  if (map['addresses'] != null) {
    if (map['addresses'] is String) {
      // Si el campo addresses es una cadena, decodificamos el JSON a una lista de direcciones
      addresses = (json.decode(map['addresses']) as List)
          .map((address) => Address.fromMap(address))
          .toList();
    } else if (map['addresses'] is List) {
      // Si el campo addresses ya es una lista, simplemente la asignamos
      addresses = (map['addresses'] as List)
          .map((address) => Address.fromMap(address))
          .toList();
    }
  }

  return User(
    id: map['id'],
    firstName: map['firstName'],
    lastName: map['lastName'],
    birthDate: DateTime.parse(map['birthDate']),
    addresses: addresses,
  );
}



  String toJson() => json.encode(toMap());

  factory User.fromJson(String jsonStr) =>
      User.fromMap(json.decode(jsonStr));
}
