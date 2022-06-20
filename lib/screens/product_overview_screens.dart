import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screens.dart';
import '../widgets/app_drawer.dart';
// import '../providers/product_provider.dart';

enum FilterOptions { favorites, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showFavorites = false;

  @override
  Widget build(BuildContext context) {
    // final providerContaner = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: <Widget>[
          Consumer<Cart>(
            builder: ((_, cart, ch) => Badge(
                  child: ch as Widget,
                  value: cart.itemsInCart.toString(),
                  color: Colors.blue.shade800,
                )),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  showFavorites = true;
                } else {
                  showFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => const [
              PopupMenuItem(
                child: Text("Only favorites"),
                value: FilterOptions.favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.all,
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsGrid(
        showFavorites: showFavorites,
      ),
    );
  }
}
