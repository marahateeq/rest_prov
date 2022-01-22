import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class Product with ChangeNotifier{

  final String id ;
  //final String restaurantId;
  final String title ;
  final String description ;
  final double price ;
  final String imageUrl ;
  final String category;
  bool isFavorite ;

  Product(
      {
       // this.restaurantId,
        this.id,
        this.title,
        this.category,
        this.description,
        this.price,
        this.imageUrl,
        this.isFavorite = false,
      });























}


