// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rest_prov/providers/auth.dart';
// import 'package:rest_prov/screens/manage_products_screen.dart';
//
// import '../providers/restuarants.dart';
// import '../screens/auth_sc.dart';
// import '../screens/profile.dart';
//
// class MyDrawer extends StatefulWidget {
//   MyDrawer({Key key}) : super(key: key);
//
//   @override
//   _MyDrawerState createState() => _MyDrawerState();
// }
//
// class _MyDrawerState extends State<MyDrawer> {
//   bool _isFa = true;
//   String _myname = "";
//   Future<void> getresO() async {
//     await Provider.of<Restaurants>(context, listen: false).fetchRestaurant();
//     Map n = Provider.of<Restaurants>(context, listen: false).rest;
//     _myname = (n['name']);
//     _isFa = false;
//     print(_myname);
//   }
//
//   @override
//   void initState() {
//     getresO();
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: _isFa == true
//           ? CircularProgressIndicator()
//           : Drawer(
//               child: Column(
//                 children: [
//                   UserAccountsDrawerHeader(
//                     currentAccountPicture:
//                         CircleAvatar(backgroundColor: Colors.deepOrange),
//                     accountName: Text(_myname), //Text("${user.uid}"),
//                     accountEmail: Text('hhhf'), // Text("${user.email}")
//                   ),
//                   ListTile(
//                     title: Text("Profile"),
//                     leading: Icon(Icons.restaurant),
//                     onTap: () {
//                       Navigator.of(context).pushNamed(Profile.routeName);
//                     },
//                   ),
//                   ListTile(
//                     title: Text("Rest_Menu"),
//                     leading: Icon(Icons.fastfood),
//                     onTap: () {
//                       Navigator.of(context)
//                           .pushNamed(ManageProductsScreen.routeName);
//                     },
//                   ),
//                   ListTile(
//                     title: Text("Delivery_orders"),
//                     leading: Icon(Icons.delivery_dining_sharp),
//                     onTap: () {
//                       Navigator.of(context).pushReplacementNamed("cart");
//                     },
//                   ),
//                   ListTile(
//                     title: Text("Reservation_orders"),
//                     leading: Icon(Icons.chair),
//                     onTap: () {
//                       Navigator.of(context).pushReplacementNamed("homepage");
//                     },
//                   ),
//                   ListTile(
//                     title: Text("Notifications"),
//                     leading: Icon(Icons.notifications_active),
//                     onTap: () {
//                       Navigator.of(context).pushReplacementNamed("homepage");
//                     },
//                   ),
//                   ListTile(
//                       title: Text("Logout"),
//                       leading: Icon(Icons.exit_to_app),
//                       onTap: () async {
//                         await Provider.of<Auth>(context, listen: false)
//                             .logout();
//                         Navigator.of(context)
//                             .pushReplacementNamed(AuthSC.routeName);
//                       }),
//                 ],
//               ),
//             ),
//     );
//   }
// }
