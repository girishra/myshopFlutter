import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool loading = true;
  List categoryList;
  Map data;
  getQuestions() async {
    http.Response response =
    await http.get('http://192.168.43.243:3000/MySHop/user/getAllOrders');
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
  @override
  void initState() {
    getQuestions();
    // TODO: implement initState

  }

  @override
  Widget build(BuildContext context) {

    // final items= List<String>.generate(4, (i) => "Item $i");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
         body: loading ? new Center(
              child: new Center(child: Text(""),),
                  ): categoryList.length != 0 ?
                  ListView.builder(
        itemCount: categoryList.length,
        itemBuilder: (context, index) {
          return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,0,0),
                    child: Image.asset("assets/iphone11.png",height: 200,width: 120,),
                  ),

                  SizedBox(width: 10,),

                  Center(
                    child: Column(
                      children: <Widget>[
                        Center(child: Text(categoryList[index]['title'],style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
                        SizedBox(height: 25,),
                        Container(child: Text(categoryList[index]['description'],maxLines: 3,))

                      ],
                    ),
                  )
                ],
              ),
            ),
          )

        ],

      );
        },
      ):new Center(child: Text("No Orders"),),
      )
    );


  }
}



