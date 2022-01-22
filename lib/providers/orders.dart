import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cart.dart';


class OrderItem{


  final String id ;
  final double amount ;
  final List<CartItem> products ;
  final DateTime dateTime ;


  OrderItem( {
     this.id,
     this.amount,
     this.products,
     this.dateTime,

  });

}



class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];


   String authToken = '';
   String userId = '';

  getData( String authTok ,String uId, List<OrderItem> orders){
    authToken = authTok ;
    userId = uId;
    _orders = orders;
    notifyListeners();
  }

  List<OrderItem> get orders{
    return [..._orders];
  }


  Future<void> fetchAndSetOrders () async{

    final url = 'https://test1-cf86f-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    // final : will not change
    try{
      final res = await http.get(Uri.parse(url));
      final extractData = json.decode(res.body) as Map<String ,dynamic>;
      if (extractData == null){
        return;
      }

      final List<OrderItem> loadedOrders = [];
      extractData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id : orderId,
          amount : orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products:  (orderData['products'] as List<dynamic>)
              .map((item) =>
              CartItem(id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'])).toList(),

        ));
        _orders = loadedOrders.reversed.toList();   //reversed:  اخر طلب يصبح بالبداية
        notifyListeners();
      });

    }catch(e){
      throw e ;
    }
  }


  //////////////////////

  Future<void> addOrders( List<CartItem> cartProduct , double total ) async{

    final url = 'https://test1-cf86f-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';//

    try{
      final timestamp = DateTime.now();
      final res = await http.post(Uri.parse(url) ,
          body: json.encode(  // send data to firebase
          {
            'amount' : total,
            'dateTime' : timestamp.toString(),
            'products' : cartProduct.map((cartprod) =>
            {
              'id' : cartprod.id,
              'title' : cartprod.title,
              'quantity' : cartprod.quantity,
              'price' : cartprod.price,
              'resId' : cartprod.restId
            }).toList(),
          }
      ) ) ;

    _orders.insert(0, OrderItem(id: json.decode(res.body)['name'],
        amount: total,
        products: cartProduct,
        dateTime: timestamp,
    ));

      notifyListeners();
    }catch(e){
      throw e;
    }


  }






}



