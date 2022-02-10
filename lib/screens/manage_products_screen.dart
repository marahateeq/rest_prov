import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_prov/providers/products.dart';
import 'package:rest_prov/widgets/bottomnavigationbar.dart';
import 'package:rest_prov/widgets/mydrawer.dart';
import 'package:rest_prov/widgets/product_item.dart';

import '../providers/product.dart';
import 'edit_product_screen.dart';




class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/ManageProductsScreen';
  const ManageProductsScreen({Key key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {

     await Provider.of<Products>(context , listen: false).fetchAndSetProducts();
  }
  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("your Products "),
        actions: [
          IconButton(icon: Icon(Icons.search),
            onPressed: () async {
              //final productdata = await Provider.of<Products>(context, listen: false);
              //final listprod = productdata.items;
              //print(productdata.items);

              showSearch(context: context, delegate: DataSearch());
            },
          ),

        ],
      ),

      //drawer: MyDrawer(),

      body: FutureBuilder(
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

      bottomNavigationBar: BottomNavBar(),

      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.deepOrange,
        onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName),
        child: const Icon(Icons.add),
        /*foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(0),

          ),
          side: BorderSide(color: Colors.orangeAccent , width: 5),
        ),
         */
        splashColor: Colors.black,

      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,


    );
  }
}

class DataSearch extends SearchDelegate {

  final list = ['t5pojgpfig', 'fsadfg' , 'pizza' , 'foof'] ;


  @override
  List<Widget> buildActions(BuildContext context) {
    return [ IconButton(onPressed: (){
      query = "";
    }, icon: Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (){
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      // body:
      //Navigator.of(context).pushReplacementNamed("restaurants")

    );



  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //var searchlist1 = query.isEmpty ? list :list.where((p) => p.startsWith(query)).toList() ;

    List filternames = list.where((element) => element.startsWith("$query")).toList();

    return ListView.builder(
        itemCount:query == "" ? list.length : filternames.length ,
        itemBuilder: (context , i){
          return InkWell(
              onTap: (){
                query = query == "" ? list[i] : filternames[i];
                //showResults(context);
                Navigator.of(context).pushReplacementNamed("restaurants");
              },

              child:
              ListTile(
                  leading: Icon(Icons.restaurant),
                  title:    query == "" ? Text("${list[i]}",
                    style: TextStyle(fontSize: 25),)
                      : Text("${filternames[i]}",
                    style: TextStyle(fontSize: 25),)

              )
          );

        });

  }



}