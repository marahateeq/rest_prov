import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_prov/const/colors.dart';
import 'package:rest_prov/utils/helper.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';
import '../widgets/searchbar.dart';
import 'manage_products_screen.dart';


class CategoryItems extends StatelessWidget {
  static const routeName = '/CategoryItems';


  Future<void> _refreshProducts(BuildContext context) async {

    final category = ModalRoute.of(context).settings.arguments;
    await Provider.of<Products>(context , listen: false).fetchProductsCategory(category);
  }


  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title:  Text('${category}',
          style: Helper.getTheme(context).headline5,
        ),
        actions: [
          IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            showSearch(context: context, delegate: DataSearch());
          },
        ),
        ],

      ),
      body:
            FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx , AsyncSnapshot snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator(),)
            :RefreshIndicator(
            child: Consumer<Products>(builder:
                (ctx , productsData , _ )
            => Padding(padding: EdgeInsets.all(8),
              child: ListView.builder(

                  itemCount: productsData.items.length,
                  itemBuilder: (_ , index )=> Column(
                    children: [
                      ProductItem(
                          productsData.items[index].id ,
                          productsData.items[index].title ,
                          productsData.items[index].imageUrl),
                      Divider(),
                    ],
                  )),
            ),

            ),
            onRefresh: ()=> _refreshProducts(context)) ,
      ),




    );
  }
}

class DessertCard extends StatelessWidget {
  const DessertCard({
    Key key,
    @required String name,
    @required String rating,
    @required String shop,
    @required Image image,
  })  : _name = name,
        _rating = rating,
        _shop = shop,
        _image = image,
        super(key: key);

  final String _name;
  final String _rating;
  final String _shop;
  final Image _image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: _image,
          ),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 70,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name,
                    style: Helper.getTheme(context).headline4.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset("images/star_filled.png",
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _rating,
                        style: TextStyle(color: AppColor.orange),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _shop,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          ".",
                          style: TextStyle(color: AppColor.orange),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Desserts",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}