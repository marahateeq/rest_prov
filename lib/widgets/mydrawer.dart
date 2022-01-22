import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_prov/providers/auth.dart';
import 'package:rest_prov/screens/edit_rest_info.dart';
import 'package:rest_prov/screens/manage_products_screen.dart';


class MyDrawer extends StatefulWidget {
  MyDrawer({ Key  key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

@override
Widget build(BuildContext context) {

return Container (
  child : Drawer(
    child: Column(
        children: [
        UserAccountsDrawerHeader(currentAccountPicture: CircleAvatar(backgroundColor: Colors.deepOrange)
        ,accountName: Text('hh') , //Text("${user.uid}"),
        accountEmail: Text('hhhf') , // Text("${user.email}")
        ),

        ListTile(
        title: Text("Profile"),
        leading: Icon(Icons.restaurant),
        onTap: ()  {

          Navigator.of(context).pushNamed(EditResInfo.routeName);
        },
        ),
        ListTile(
        title: Text("Rest_Menu"),
        leading: Icon(Icons.fastfood),
        onTap: ()  {
        Navigator.of(context).pushNamed(ManageProductsScreen.routeName);
        },
        ),

        ListTile(
        title: Text("Delivery_orders"),
        leading: Icon(Icons.delivery_dining_sharp),
        onTap: ()  {Navigator.of(context).pushReplacementNamed("cart");},
        ),

          ListTile(
            title: Text("Reservation_orders"),
            leading: Icon(Icons.chair),
            onTap: ()  {
              Navigator.of(context).pushReplacementNamed("homepage");
            },
          ),
          ListTile(
            title: Text("Notifications"),
            leading: Icon(Icons.notifications_active),
            onTap: ()  {
              Navigator.of(context).pushReplacementNamed("homepage");
            },
          ),
        ListTile(
        title: Text("Logout"),
        leading: Icon(Icons.exit_to_app),
        onTap: () {
        Provider.of<Auth>(context , listen: false).logout();
        }

        ),
        ],
        ),

        ),
          );


}
}
