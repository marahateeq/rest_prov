import 'package:flutter/material.dart';
import 'package:rest_prov/screens/menu_screen.dart';
import 'package:rest_prov/screens/profile.dart';
import 'package:rest_prov/widgets/bottomnavigationbar.dart';
import 'package:rest_prov/widgets/mydrawer.dart';

import 'delivery_orders_screen.dart';
import 'manage_products_screen.dart';
int i = 0;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  static const routeName = '/homepage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
   // final _restaurant = ModalRoute.of(context).settings.arguments as Restaurant;

  final dS = MediaQuery.of(context).size;

  return  Scaffold(
        appBar: AppBar(
          title: Text(' hi', ),

        ),
      drawer: MyDrawer(),

       body:
    SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(

            margin: EdgeInsets.all(20),

              child: Row(
                children: [
                  Column(

                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),

                        child: GestureDetector(
                          onTap: ()=> Navigator.of(context).pushNamed(Profile.routeName , //arguments: _restaurant
                          ),
                          child: Image.asset("images/profile.png",
                            width: dS.width * 0.3,

                            fit : BoxFit.fill ,
                          ),
                        ),

                        //backgroundColor: Colors.black87,


                      ),
                      SizedBox(height: 15,),
                      Text("Profile ", textAlign: TextAlign.center,style: TextStyle(fontSize: 20 ,color: Colors.deepOrange), ),

                    ],
                  ),
                  SizedBox(width: 10,),
                  Column(

                    children: [
                      ClipRRect(

                        borderRadius: BorderRadius.circular(10),

                        child: GestureDetector(
                          onTap: ()=> Navigator.of(context).pushNamed(MenuScreen.routeName),
                          child: Image.asset("images/m2.png",
                            width: dS.width * 0.3,
                            fit : BoxFit.fill ,
                          ),
                        ),

                        //backgroundColor: Colors.black87,


                      ),
                      SizedBox(height: 15,),
                      Text("Menu", textAlign: TextAlign.center,style: TextStyle(fontSize: 20 , color: Colors.deepOrange), ),

                    ],
                  )
                ],
              ),

          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              children: [
                Column(

                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child: GestureDetector(
                        onTap: ()=> Navigator.of(context).pushNamed(DeliveryOrdersScreen.routeName),
                        child: Image.asset("images/t3.png",
                          width: dS.width * 0.3,

                          fit : BoxFit.cover ,
                        ),
                      ),

                      //backgroundColor: Colors.black87,


                    ),
                    SizedBox(height: 15,),
                    Text("Reservation_Orders", textAlign: TextAlign.center,style: TextStyle(fontSize: 20 , color: Colors.deepOrange), ),

                  ],
                ),
                SizedBox(width: 10,),
                Column(

                  children: [
                    ClipRRect(

                      borderRadius: BorderRadius.circular(10),

                      child: GestureDetector(
                        onTap: ()=> Navigator.of(context).pushNamed(MenuScreen.routeName),
                        child: Image.asset("images/d.png",
                          width: dS.width * 0.3,
                          fit : BoxFit.fill ,
                        ),
                      ),

                      //backgroundColor: Colors.black87,


                    ),
                    SizedBox(height: 15,),
                    Text("Delivery_Orders", textAlign: TextAlign.center,style: TextStyle(fontSize: 20 ,color: Colors.deepOrange),),

                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              children: [
                Column(

                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child: GestureDetector(
                        onTap: ()=> Navigator.of(context).pushNamed(MenuScreen.routeName),
                        child: Image.asset("images/n.png",
                          width: dS.width * 0.3,

                          fit : BoxFit.fill ,
                        ),
                      ),

                      //backgroundColor: Colors.black87,


                    ),
                    SizedBox(height: 15,),
                    Text("Notifications", textAlign: TextAlign.center,style: TextStyle(fontSize: 20 , color: Colors.deepOrange), ),

                  ],
                ),
                SizedBox(width: 10,),
                Column(

                  children: [
                    ClipRRect(

                      borderRadius: BorderRadius.circular(10),

                      child: GestureDetector(
                        onTap: ()=> Navigator.of(context).pushNamed(MenuScreen.routeName),
                        child: Image.asset("images/offer.png",
                          width: dS.width * 0.3,
                          fit : BoxFit.fill ,
                        ),
                      ),

                      //backgroundColor: Colors.black87,


                    ),
                    SizedBox(height: 15,),
                    Text("Offers", textAlign: TextAlign.center,style: TextStyle(fontSize: 20 ,color: Colors.deepOrange), ),

                  ],
                )
              ],
            ),
          ),
          Container(

            margin: EdgeInsets.all(20),

            child: Row(
              children: [
                Column(

                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child: GestureDetector(
                        onTap: ()=> Navigator.of(context).pushNamed(ManageProductsScreen.routeName , //arguments: _restaurant
                        ),
                        child: Image.asset("images/m77.png",
                          width: dS.width * 0.2,

                          fit : BoxFit.fill ,
                        ),
                      ),

                      //backgroundColor: Colors.black87,


                    ),
                    SizedBox(height: 15,),
                    Text("Manage Products  ", textAlign: TextAlign.center,style: TextStyle(fontSize: 20 ,color: Colors.deepOrange), ),

                  ],
                ),



              ],
            ),

          ),

        ],
      ),
    ),






       /*ElevatedButton(
         onPressed: (){
           Navigator.of(context).pushNamed(MenuScreen.routeName);
         },
         child: Text('Menu'),
       ),*/
      //bottomNavigationBar: BottomNavBar(),


    );
  }
}
