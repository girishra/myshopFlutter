import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/myCart.dart';
import 'package:my_shop/orderDetails.dart';
import 'listProduct.dart';
import 'main.dart';
import 'loginPage.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: NavPage(),
    );
  }
}

class NavPage extends StatefulWidget {
  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              // sharedPreferences.clear();
              // sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>LoginPage()), (Route<dynamic> route)=>false);
            },
            child: Text(
                "Logout"
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
              iconData: Icons.home,
              title: "Home",
              onclick: () {
                final FancyBottomNavigationState fState =
                    bottomNavigationKey.currentState;
                fState.setPage(2);
              }),
          TabData(
              iconData: Icons.chat,
              title: "Order Details",
              onclick: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => OrderDetails()))),
          TabData(iconData: Icons.shopping_cart, title: "Cart")
        ],
        initialSelection: 1,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),

    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return listProducts();
      case 1:
        return OrderDetails();
      case 2:
        return MyCart();
      default:
        return listProducts();
    }
  }
}