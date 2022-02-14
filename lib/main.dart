import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_prov/providers/auth.dart';
import 'package:rest_prov/providers/orders.dart';
import 'package:rest_prov/providers/products.dart';
import 'package:rest_prov/providers/restuarants.dart';
import 'package:rest_prov/screens/auth_sc.dart';
import 'package:rest_prov/screens/category_items.dart';
import 'package:rest_prov/screens/delivery_orders_screen.dart';
import 'package:rest_prov/screens/edit_product_screen.dart';
import 'package:rest_prov/screens/edit_rest_info.dart';
import 'package:rest_prov/screens/homepage.dart';
import 'package:rest_prov/screens/manage_products_screen.dart';
import 'package:rest_prov/screens/menu_screen.dart';
import 'package:rest_prov/screens/profile.dart';
import 'package:rest_prov/screens/splash_sc.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        //ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(),
            update: (ctx, authValue, previousProducts) => previousProducts
              ..getData(
                authValue.token,
                authValue.userID,
                previousProducts == null ? null : previousProducts.items,
              )),
        ChangeNotifierProxyProvider<Auth, Restaurants>(
            create: (_) => Restaurants(),
            update: (ctx, authValue, previousRestaurants) => previousRestaurants
              ..getData(
                authValue.token,
                authValue.userID,
                previousRestaurants == null ? null : previousRestaurants.items,
              )),

        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders(),
            update: (ctx, authValue, previousOrders) => previousOrders
              ..getData(
                authValue.token,
                authValue.userID,
                previousOrders == null ? null : previousOrders.orders,
              )),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: '',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            fontFamily: 'Lat',
          ),
          home: auth.isAuth
              ? HomePage()
              : FutureBuilder(
                  future: auth.tryAutoLogIn(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const SplashSC()
                          : const AuthSC()),
          routes: {
            AuthSC.routeName: (_) => const AuthSC(),
            ManageProductsScreen.routeName: (_) => const ManageProductsScreen(),
            EditProductScreen.routeName: (_) => const EditProductScreen(),
            EditResInfo.routeName: (_) => const EditResInfo(),
            HomePage.routeName: (_) => const HomePage(),
            MenuScreen.routeName: (_) => MenuScreen(),
            CategoryItems.routeName: (_) => CategoryItems(),
            Profile.routeName: (_) => Profile(),
            DeliveryOrdersScreen.routeName: (_) => DeliveryOrdersScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

// var fmt = DateFormat("HH:mm").format(now);
