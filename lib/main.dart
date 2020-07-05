//  import 'package:flutter/material.dart';
// import 'Screens/SplashScreen.dart';
// import 'Screens/Login.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addProduct.dart';
import 'listProduct.dart';
import 'loginPage.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app node js',
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      home:LoginPage() ,
      
    );
  }
}