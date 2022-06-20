import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import "./screens/product_overview_screens.dart";
import './screens/product_details_screen.dart';
import "./providers/product_provider.dart";
import './providers/cart.dart';
import './screens/cart_screens.dart';
import './providers/orders.dart' show Order;
import './screens/orders_screens.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext ctx) {
          return Products();
        }),
        ChangeNotifierProvider(create: (BuildContext ctx) {
          return Cart();
        }),
        ChangeNotifierProvider(create: (BuildContext ctx) {
          return Order();
        })
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "Lato",
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.purple,
          ).copyWith(
            secondary: Colors.deepOrange,
          ),
        ),
        routes: {
          "/": (ctx) => const ProductOverviewScreen(),
          ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.pathName: (ctx) => const OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
          EditProductsScreen.routeName: (ctx) => const EditProductsScreen(),
        },
      ),
    );
  }
}
