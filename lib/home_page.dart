import 'dart:convert';
import 'dart:io';
import 'package:assignment_api_integration/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  //keep API data in this list after fetching
  List<ProductModel> proList = [];

  //method for fetching data
  Future fetchData() async {
    //make http request for fetching data from server
    final response = await http.get(
      Uri.parse('https://pqstec.com/invoiceapps/Values/GetProductList'),
      // Send authorization token headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            //used token for authorization
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOiI3OCIsIkN1cnJlbnRDb21JZCI6IjEiLCJuYmYiOjE2NzM0MzMxMTYsImV4cCI6MTY3NDAzNzkxNiwiaWF0IjoxNjczNDMzMTE2fQ.Qij1qVHRc8wSFWoktVKnoVwY89dEwiHIQI94-b33CsY',
      },
    );
    var jsonData = jsonDecode(response.body);
    //used foreach loop for store API data to model
    for (var product in jsonData['ProductList']) {
      final productList = ProductModel(
          product['CategoryName'],
          product['UnitName'],
          product['Name'],
          product['BrandName'],
          product['ModelName'],
          product['OldPrice'],
          product['Price']);
      //add data to list
      proList.add(productList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //create app bar
        appBar: AppBar(
          leading: Icon(
            Icons.menu,
            size: 30,
            color: Colors.white,
          ),
          title: Text(
            "Product List",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
              future: fetchData(),
              builder: (_, snapshot) {
                //if loading is done then it shows the data
                if (snapshot.connectionState == ConnectionState.done) {
                  //used listview builder to create the list of children But recursively without writing code again and again
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: proList.length,
                      itemBuilder: (_, index) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          height: 170,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.redAccent.shade100.withOpacity(0.2),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Colors.grey.shade200.withOpacity(0.5),
                                    blurRadius: 10)
                              ]),
                          child: Row(
                            children: [
                              //product image
                              Container(
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                    image: DecorationImage(
                                        image:
                                            AssetImage("lib/images/mobile.jpg"),
                                        fit: BoxFit.cover)),
                              ),
                              //to display the data
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      proList[index].CategoryName,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      proList[index].Name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey.shade600),
                                    ),
                                    Text(
                                      proList[index].UnitName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey.shade600),
                                    ),
                                    Text(
                                      proList[index].BrandName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey.shade600),
                                    ),
                                    Text(
                                      proList[index].ModelName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey.shade600),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${proList[index].price}",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.grey.shade800,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Text(
                                          "${proList[index].oldPrice}",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.w500,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                }
                //if it's still loading then show the circular progress indicator
                else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
