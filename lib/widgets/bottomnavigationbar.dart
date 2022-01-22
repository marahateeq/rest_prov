import 'package:flutter/material.dart';
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
      Navigator.of(context).pushReplacementNamed(ManageProductsScreen.routeName);}
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

          BottomNavigationBarItem(label : "Rest_Menu",icon: Icon(Icons.restaurant_menu)),
          BottomNavigationBarItem(label : "Orders",icon: Icon(Icons.shopping_cart_outlined)),

        ],


      );


  }
}
