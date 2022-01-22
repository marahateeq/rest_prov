import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class Restaurant with ChangeNotifier {

  final String id;
  final String name;
  final String address;
  final String imageUrl ;

  //List<Product> _menu = [];

  Restaurant({
    this.id,
    this.name,
    this.address,
    this.imageUrl,
   // required this.menu,
  });







}