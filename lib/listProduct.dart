import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/myCart.dart';
import 'package:my_shop/productDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'details.dart';

class listProducts extends StatefulWidget {
  static const routeName = '/categories';
  _HomePageState createState() => _HomePageState();
}
const String spKey = 'myBool';
class _HomePageState extends State<listProducts> {
   SharedPreferences sharedPreferences;
  String userData;
  List categoryList;
  Map data;
  String idd;

  getQuestions() async {
    http.Response response =
    await http.get('http://192.168.43.243:3000/MySHop/user/getAllProducts',headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'JWT $userData',
    });
    data = json.decode(response.body);
    setState(() {
      categoryList = data['data'];
    });
    debugPrint(response.body);
  }

  @override
  void initState() {
     SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      userData = sharedPreferences.getString('tokenn');
      print(userData);
      if (userData == null) {
        userData = "";
        persist(userData);
      }
      setState(() {});
    });
    super.initState();
    getQuestions();
  }

void persist(String value) {
    setState(() {
      userData = value;

    });
    sharedPreferences?.setString(spKey, value);
  }

  int _n = 0;

  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0)
        _n--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  //       appBar: AppBar(
  //         title: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //                Container(
  //                 padding: const EdgeInsets.all(5.0), child: Text('Products')),
  //              GestureDetector(
  //                onTap: (){
  //                                    Navigator.push(context,new MaterialPageRoute(builder: (context) => new MyCart()));

  //                },
  //                               child: Image.asset(
  //                  'assets/cart.png',
  //                   fit: BoxFit.contain,
  //                   height: 32,
  //             ),
  //              ),
              
  //           ],

  //         ),
  // ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
//        itemCount: categoryList == null ? 0 : categoryList.length,
        itemCount: categoryList == null ? 0 : categoryList.length,

        itemBuilder: (BuildContext context, int index){
          print("categoryyy");
          print(categoryList);
          int _itemCount = 0;

          return GestureDetector(
            child: Container(
              margin: EdgeInsets.fromLTRB(30,20,30,20),

              child: Card(

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft:  Radius.circular(40)),
                ),
                elevation: 8,
                child: Column(children: <Widget>[


                  Image.asset("assets/iphone11.png",width: 400,height: 120,),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    categoryList[index]['title'],
                    style: TextStyle(color: Colors.black87, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                Text("₹"+categoryList[index]['price']),

                  SizedBox(height: 20),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      child: RaisedButton(
                        elevation: 0,
                        child: Text("More Info"),
                        onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(idd:categoryList[index]['_id'])));

                        },
                      ),
                    ),
                  )
                ]
                ),
              ),
            ),
          );

        } ,
      ),
    );
  }
}


