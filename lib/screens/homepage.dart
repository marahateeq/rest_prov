import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_prov/screens/menu_screen.dart';
import 'package:rest_prov/screens/profile.dart';

import '../providers/auth.dart';
import '../providers/restuarants.dart';
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
  String info;

  Future<void> emver() async {
    await Provider.of<Auth>(context, listen: false).userData();
    bool v = await Provider.of<Auth>(context, listen: false).emailverified;
    if (v == false) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.INFO,
        body: Center(
          child: Text(
            'your email address not verified , Please check your email! ',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        title: 'Verify',
        btnCancelOnPress: () async {
          await Provider.of<Auth>(context, listen: false).logout();
        },
        //desc: 'This is also Ignored',
        btnOkOnPress: () async {
          await Provider.of<Auth>(context, listen: false).sendE().then(
              (value) async =>
                  await Provider.of<Auth>(context, listen: false).logout());
        },
      )..show();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _islo = true;
  String myname = "Just Eat";

  // Future<void> getres() async {
  //    Provider.of<Restaurants>(context, listen: false)
  //       .fetchRestaurant()
  //       .whenComplete(() => _islo = false);
  // }

  bool _isl = true;
  @override
  void initState() {
    super.initState();
    Provider.of<Restaurants>(context, listen: false).fetchRestaurant().then(
          (_) => setState(
            () => _islo = false,
          ),
        );
    emver();
  }

  @override
  Widget build(BuildContext context) {
    // final _restaurant = ModalRoute.of(context).settings.arguments as Restaurant;
    final n = Provider.of<Restaurants>(context, listen: false).username;
    String myname = n;
    final emaild = Provider.of<Auth>(context, listen: false);
    final uemail = emaild.emaildata;

    final dS = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            ' Just Eat',
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture:
                    CircleAvatar(backgroundColor: Colors.deepOrange),
                accountName: myname == null
                    ? Text(' ')
                    : Text('${myname}'), //Text("${user.uid}"),
                accountEmail: uemail == null
                    ? const Text('')
                    : Text(uemail), // Text("${user.email}")
              ),
              ListTile(
                title: Text("Profile"),
                leading: Icon(Icons.restaurant),
                onTap: () {
                  Navigator.of(context).pushNamed(Profile.routeName);
                },
              ),
              ListTile(
                title: Text("Rest_Menu"),
                leading: Icon(Icons.fastfood),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ManageProductsScreen.routeName);
                },
              ),
              ListTile(
                title: Text("Delivery_orders"),
                leading: Icon(Icons.delivery_dining_sharp),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed("cart");
                },
              ),
              ListTile(
                title: Text("Reservation_orders"),
                leading: Icon(Icons.chair),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed("homepage");
                },
              ),
              ListTile(
                title: Text("Notifications"),
                leading: Icon(Icons.notifications_active),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed("homepage");
                },
              ),
              ListTile(
                  title: Text("Logout"),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).logout();
                  }),
            ],
          ),
        ),
        body: _islo
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ElevatedButton(
                        //   onPressed: () {
                        //     //print('${n['name']}');
                        //     // Location().determinePosition();
                        //   },
                        //   child: Text('email'),
                        // ),
                        Container(
                          margin: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),

                                    child: GestureDetector(
                                      onTap: () =>
                                          Navigator.of(context).pushNamed(
                                        Profile
                                            .routeName, //arguments: _restaurant
                                      ),
                                      child: Image.asset(
                                        "images/profile.png",
                                        width: dS.width * 0.3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    //backgroundColor: Colors.black87,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Profile ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),

                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(MenuScreen.routeName),
                                      child: Image.asset(
                                        "images/m2.png",
                                        width: dS.width * 0.3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    //backgroundColor: Colors.black87,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Menu",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.deepOrange),
                                  ),
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
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(
                                              DeliveryOrdersScreen.routeName),
                                      child: Image.asset(
                                        "images/t3.png",
                                        width: dS.width * 0.3,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    //backgroundColor: Colors.black87,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Reservation_Orders",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),

                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(MenuScreen.routeName),
                                      child: Image.asset(
                                        "images/d.png",
                                        width: dS.width * 0.3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    //backgroundColor: Colors.black87,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Delivery_Orders",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.deepOrange),
                                  ),
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
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(MenuScreen.routeName),
                                      child: Image.asset(
                                        "images/n.png",
                                        width: dS.width * 0.3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    //backgroundColor: Colors.black87,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Notifications",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),

                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(MenuScreen.routeName),
                                      child: Image.asset(
                                        "images/offer.png",
                                        width: dS.width * 0.3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    //backgroundColor: Colors.black87,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Offers",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.deepOrange),
                                  ),
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
                                      onTap: () =>
                                          Navigator.of(context).pushNamed(
                                        ManageProductsScreen
                                            .routeName, //arguments: _restaurant
                                      ),
                                      child: Image.asset(
                                        "images/m77.png",
                                        width: dS.width * 0.2,
                                        fit: BoxFit.fill,
                                      ),
                                    ),

                                    //backgroundColor: Colors.black87,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Manage Products  ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.deepOrange),
                                  ),
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
                ],
              ));
  }
}
