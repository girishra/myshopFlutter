import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'PatmentScreen.dart';
import 'productDetails.dart';
import 'package:http/http.dart' as http;

class MyCart extends StatefulWidget {
  String idd = "";
  MyCart({Key key,this.idd}) : super(key: key);

  @override
  MyCartState createState() {
    return MyCartState();
  }
}

class MyCartState extends State<MyCart> {
   List categoryList;
  Map data;
  bool loading = true;
  // final items = List<String>.generate(categoryList.length, (i) => "Item ${i + 1}");
getCart() async {
    http.Response response =
    await http.get('http://192.168.43.243:3000/MySHop/user/getAllCartProducts');
    data = json.decode(response.body);
    setState(() {
      categoryList = data['data'];
       loading = false;
       if(data['status']==false){
         loading=true;
       }
    });
    debugPrint(response.body);
  }
  _makePatchRequest() async {
  // set up PATCH request arguments
  String url = "http://192.168.43.243:3000/MySHop/user/addOrder/"+widget.idd;
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"isOrdered": "true"}';
  // make PATCH request
  http.Response response = await http.patch(url, headers: headers, body: json);
  int statusCode = response.statusCode;
  String body = response.body;
  print(body);
  print(statusCode);
}
_removeFromCart() async {
  // set up PATCH request arguments
  String url = "http://192.168.43.243:3000/MySHop/user/addToCart/"+widget.idd;
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"cartItem": "false"}';
  // make PATCH request
  http.Response response = await http.patch(url, headers: headers, body: json);
  int statusCode = response.statusCode;
  String body = response.body;
  print(body);
  print(statusCode);
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCart();
     SchedulerBinding.instance.addPostFrameCallback((_) => loadData());
  }

  loadData() {
    getCart();
    _makePatchRequest();
    // _removeFromCart();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        
         body: loading ? new Center(
              child: new Center(child: Text(""),),
                  ): categoryList.length != 0 ?
        Column(

          children: <Widget>[
            Container(
              height: 500,
              width: 400,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => ProductDetails()));

                },
                child: ListView.builder(
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
 Map<String, dynamic> item = categoryList[index];
                    return Dismissible(
                      key: Key(item.toString()),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) {
                        _removeFromCart();
                        // Remove the item from the data source.
                        setState(() {
                          _removeFromCart();
                          categoryList.removeAt(index);
                        });

                        // Then show a snackbar.
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text("$item Removed")));
                      },
                      // Show a red background as the item is swiped away.
                      background: Container(color: Colors.red[900]),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,2,0,2),

                        child: Container(
                          color:Colors.lightBlue[50],
                          child: ListTile(
                              leading: Image.asset("assets/iphone11.png"),
                              title: Text(categoryList[index]['title']),onTap: (){
//                            Navigator.push(context, new MaterialPageRoute(builder: (context) => PaymenScreen()));
                          },
                              subtitle: Text(
                                  'Product title'
                              ),
                              trailing:Container(
                                height: 40,
                                width: 50,
                                decoration:
                                BoxDecoration(border: Border.all(color: Colors.white)),

                                child: Center(child: Text('\₹'+ categoryList[index]['price'],style: TextStyle(fontSize: 18,color: Colors.grey),)),
                              )
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          ],
        ):new Center(child: Text("No products"),),

        bottomSheet: Container(
          height: 100,
          width: 500,
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: OutlineButton(
                        borderSide: BorderSide(color: Colors.green),
                        child: const Text('Place order'),
                        textColor: Colors.green,
                        onPressed: () {
                          _makePatchRequest();
                          //   Navigator.push(context, MaterialPageRoute(builder: (context)=> Item_Details()));
                        },
                        shape: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}