import 'package:flutter/material.dart';
import 'package:rest_prov/screens/homepage.dart';
import 'package:rest_prov/screens/manage_products_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({ Key  key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}
int _selectedIndex = 0;


class _BottomNavBarState extends State<BottomNavBar> {




  _x (int index ){
    setState(() {

      _selectedIndex = index;

    } );

    if(_selectedIndex == 0){
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);}
    if(_selectedIndex == 1){
      Navigator.of(context).pushReplacementNamed("ManageProductsScreen");}



  }
  @override
  Widget build(BuildContext context) {

    return    BottomNavigationBar(

        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,

        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.black,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        type : BottomNavigationBarType.shifting,


        onTap: _x,


        items: const [

          BottomNavigationBarItem(label : "HomePage",icon: Icon(Icons.home_filled)),
          BottomNavigationBarItem(label : "Orders",icon: Icon(Icons.shopping_cart_outlined)),

        ],


      );


  }
}
