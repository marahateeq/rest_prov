import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final TimeOfDay timeOfDay;
  bool Delivery = false;

  OrderItem(
      {this.id, this.amount, this.products, this.dateTime, this.timeOfDay ,});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  String authToken = '';
  String userId = '';

  getData(
      String authTok,
      String uId,
      List<OrderItem> orders,
      ) {
    authToken = authTok;
    userId = uId;
    _orders = orders;

    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders(bool delRes) async {

    final url =
        'https://test1-cf86f-default-rtdb.firebaseio.com/orders.json?auth=$authToken';      //?$userId.json
    // final : will not change
    try {
      final res = await http.get(Uri.parse(url));
      final extractData = json.decode(res.body) as Map<String, dynamic>;

      if (extractData == null) {
        return;
      }

      final List<OrderItem> loadedOrders = [];
       List products =[];


      extractData.forEach((orderId, orderData11) {
       // if (orderData11['delivery'] == delRes) {
          orderData11.forEach((iid, orderData) {
            products = orderData['products'];

            products.forEach((element) {

              if (element['resId'] == userId) {
                print(userId);
                loadedOrders.add(
                    OrderItem(
                      id: iid,
                      amount: orderData['amount'],
                      dateTime: DateTime.parse(orderData['datetime']),
                      timeOfDay: orderData['timeofday'],

                    )
                ); //add
                print("done");
              }
              else {
                print('no');
              }
            });
          }
          );
        }
      );

      _orders = loadedOrders.reversed.toList(); //reversed:  اخر طلب يصبح بالبداية
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //////////////////////

  Future<void> addOrders(List<CartItem> cartProduct, double total, bool status,
      TimeOfDay time, DateTime date, String no) async {
    final url =
        'https://test1-cf86f-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    try {
      final timestamp = DateTime.now();
      final res = await http.post(Uri.parse(url),
          body: json.encode(// send data to firebase
              {
                'id': userId,
                'amount': total,
                'products': cartProduct
                    .map((cartprod) => {
                  'id': cartprod.id,
                  'title': cartprod.title,
                  'quantity': cartprod.quantity,
                  'price': cartprod.price,
                  //'resId': cartprod.restId
                })
                    .toList(),
                'timeofday': time.toString(),
                'datetime': date.toString(),
                'delivery': status,
                'numberofpeople': status == true ? '0' : no,
              }));

      _orders.insert(
          0,
          OrderItem(
            id: userId,
            amount: total,
            products: cartProduct,
            dateTime: date,
            timeOfDay: time,
          ));

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
