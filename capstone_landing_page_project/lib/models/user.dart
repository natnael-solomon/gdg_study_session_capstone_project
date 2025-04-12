import 'dart:convert';

class User {
  final int id;
  final Name name;
  final String email;
  final String password;
  final String username;
  final Address address;
  final String phone;
  User({
    required this.id,
    required this.email,
    required this.password,
    required this.username,
    required this.name,
    required this.phone,
    required this.address,
  });
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      username: json['username'],
      name: Name.fromJson(json['name']),
      address:Address.fromJson(json['address']),
      phone:json['phone'],
    );

  }

}
class Name{
  final String firstname;
  final String lastname;
  Name({
    required this.firstname,
    required this.lastname,
  });
  factory Name.fromJson(Map<String, dynamic> json){
    return Name(
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}

class Address{
  final String city;
  final String street;
  final String zipcode;
  final int number;
  final Geolocation geolocation;
  Address({
    required this.city,
    required this.street,
    required this.zipcode,
    required this.number,
    required this.geolocation,
  });
  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
      city: json['city'],
      street: json['street'],
      zipcode: json['zipcode'],
      number: json['number'],
      geolocation: Geolocation.fromJson(json['geolocation']),
    );
  }
}
class Geolocation{
  final String lat;
  final String long;
  Geolocation({
    required this.lat,
    required this.long,
  });
  factory Geolocation.fromJson(Map<String, dynamic> json){
    return Geolocation(
      lat: json['lat'],
      long: json['long'],
    );
  }

}