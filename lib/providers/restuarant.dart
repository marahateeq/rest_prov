import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Restaurant with ChangeNotifier {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final String phone;
  final String opentime;
  final String closetime;
  //List<Product> _menu = [];

  Restaurant({
    this.id,
    this.name,
    this.address,
    this.imageUrl,
    this.phone,
    this.opentime,
    this.closetime,
    // required this.menu,
  });
}
