import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rest_prov/providers/product.dart';



class Products with ChangeNotifier{
  List<Product> _items = [];

  String authToken;
  String userId;




  getData(String authTok , String uId, List<Product> products)  {

    authToken = authTok;
    userId = uId;
    _items = products;
    notifyListeners();
  }

  List<Product> get items{
    return [..._items];

  }


  Product findById(String id){
    return _items.firstWhere((prod) => prod.id == id);
  }


  Future<void> fetchAndSetProducts () async{

    final filteredString = 'orderBy="creatorId"&equalTo="$userId"';
    var url = 'https://test1-cf86f-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filteredString';


    try{
      final res = await http.get(Uri.parse(url));
      final extractData = json.decode(res.body) as Map<String ,dynamic>; // key is String , value is dynamic
      // decode : receive from database

      if (extractData.toString() == null){
        return;
      }
     // url = 'https://test1-cf86f-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';//$userId.json : favorites for this user // authToken : using database only for user logged in
      //اعطيني المنتجات المفضلة بالنسبة لهاد الشخص
      //final favRes = await http.get(Uri.parse(url));
      //final favData = json.decode(favRes.body)  ; // is direct map // key is prodId give boolean value true or false


      final List<Product> loadedProducts = [];
      extractData?.forEach((prodId, prodData) {  // extractData is map ,  prodId is key , prodData is value
        loadedProducts.add(Product(
          id : prodId,
          title : prodData['title'],
          category: prodData['category'],
          description : prodData['description'],
          price : prodData['price'],
          imageUrl : prodData['imageUrl'],
        ));
        _items = loadedProducts;

        notifyListeners();
      }
      );
    }catch(e){
      rethrow ;
    }
  }


  Future<void> addProduct(Product product) async{
    final url = 'https://test1-cf86f-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try{
      final res = await http.post(   // send data to database
          Uri.parse(url) ,
          body: json.encode(  // encode :send
          {
            'title' : product.title,
            'description' : product.description,
            'imageUrl' : product.imageUrl,
            'price' : product.price,
            'category': product.category,
            'creatorId' : userId,
          }
      ) ) ;

      final newProduct = Product( // to add newProduct to the _items // notice that isFavorite not final
        //restaurantId: userId,
        id :  json.decode(res.body)['name'], // bring id from firebase
        title : product.title,
        description : product.description,
        price : product.price,
        category: product.category,
        imageUrl : product.imageUrl,
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct);
      notifyListeners();
    }catch(e){
      rethrow;
    }


  }


  Future<void> updateProduct (String id , Product newProduct) async{

    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if(prodIndex >= 0 ){ // the product is already exist

      final url = 'https://test1-cf86f-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url) , body: json.encode( // patch : تحديث , modify on url  // encode : send updated product to firebase
          {
            'title' : newProduct.title,
            'category': newProduct.category,
            'description' : newProduct.description,
            'imageUrl' : newProduct.imageUrl,
            'price' : newProduct.price,

            // creatorId can't be change
          }
      ));
       // تعديل البيانات الموجودة عندي
      _items[prodIndex] = newProduct ;
      notifyListeners(); // use it when change values
    }else{
      //print("in updateProduct ");
    }
  }


  Future<void> deleteProduct (String id ) async{

    final url = 'https://test1-cf86f-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    // delete from app firstly , then move this deleting to firebase
    final existingProductIndex =  _items.indexWhere((prod) => prod.id == id); // search the matched productId that passed to function
    Product existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final res = await http.delete(Uri.parse(url)); // delete the specific item

    if(res.statusCode >= 400 ){ // error occurred
      _items.insert(existingProductIndex, existingProduct);// back the deleted item to its specific index
      notifyListeners();
      throw const HttpException('Could not delete product');
    }
    existingProduct = null ; // not keep the previous task
  }




}










