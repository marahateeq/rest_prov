import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rest_prov/providers/restuarant.dart';




class Restaurants with ChangeNotifier {

  List<Restaurant> _items = [];
  Restaurant _rest;
  String authToken;
  String userId;

  getData(String authTok , String uId, List<Restaurant> restaurants){
    authToken = authTok;
    userId = uId;
    _items = restaurants;
    notifyListeners();
  }

  List<Restaurant> get items{
    return [..._items];
  }


  Restaurant findById(String id){
    return _items.firstWhere((rest) => rest.id == id);
  }

  Restaurant findByName(String name){
    return _items.firstWhere((rest) => rest.name == name);
  }


  Future<void> addRestaurant(Restaurant restaurant) async{
    final url = 'https://test1-cf86f-default-rtdb.firebaseio.com/restaurants.json?auth=$authToken';

    try{
      final res = await http.post(   // send data to database
          Uri.parse(url) ,
          body: json.encode(  // encode :send
              {
                'name' : restaurant.name,
                'address' : restaurant.address,
                'imageUrl' : restaurant.imageUrl,
                'creatorId' : userId,
              }
          ) ) ;

      final newRes = Restaurant( // to add newProduct to the _items // notice that isFavorite not final
        //restaurantId: userId,
        id :  userId ,//json.decode(res.body)['name'], // bring id from firebase
        name : restaurant.name,
        address : restaurant.address,
        imageUrl : restaurant.imageUrl,
      );
      _items.add(newRes);
      //_items.insert(0, newProduct);
      notifyListeners();
    }catch(e){
      rethrow;
    }


  }


  Future<void> updateRest (String id , Restaurant newRestaurant) async{

    final restIndex = _items.indexWhere((rest) => rest.id == id);

    if(restIndex >= 0 ){ // the product is already exist

      final url = 'https://test1-cf86f-default-rtdb.firebaseio.com/restaurants/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url) , body: json.encode( // patch : تحديث , modify on url  // encode : send updated product to firebase
          {
            'name' : newRestaurant.name,
            'address' : newRestaurant.address,
            'imageUrl' : newRestaurant.imageUrl,
            // creatorId can't be change
          }
      ));
      // تعديل البيانات الموجودة عندي
      _items[restIndex] = newRestaurant ;
      notifyListeners(); // use it when change values
    }else{

    }
  }


  Future<void> fetchRestaurant () async{

   // final filteredString = 'orderBy="creatorId"&equalTo="$userId"';
    var url = 'https://test1-cf86f-default-rtdb.firebaseio.com/restaurants/$userId.json?auth=$authToken';


    try{
      final res = await http.get(Uri.parse(url));
      final extractData = json.decode(res.body);
      if (extractData == null){
        return;
      }
      _rest = extractData as Restaurant;
      notifyListeners();
    }catch(e){
      throw e ;
    }
  }





























}