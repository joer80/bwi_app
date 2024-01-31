// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../constants.dart'; //ie. var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
import '../auth.dart';
import '../routing.dart';
import '../data/cartproduct.dart';

import 'dart:async'; //optional but helps with debugging
import 'dart:convert'; //to and from json
import 'package:http/http.dart' as http; //for api requests

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartProduct> productList = []; //cart products returned from API

  Future<List<CartProduct>?> getProducts(String? searchString) async {
    final token = await ProductstoreAuth().getToken();

    //print("getProducts running. _page is $_page");

    http.Request request = http.Request(
        'GET', Uri.parse(ApiConstants.baseUrl + ApiConstants.cartEndpoint));

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'application/json'; //Format sending
    request.headers['ACCEPT'] = 'application/json'; //Format recieving

    try {
      // Update to indicate that the streamedResponse and response variables can be null.
      var streamedResponse = await request.send();
      if (streamedResponse != null) {
        var response = await http.Response.fromStream(streamedResponse);

        // Add a null check to the if statement before parsing the response.
        if (response != null) {
          //Parse response
          if (response.statusCode == 200) {
            //Parse Products in JSON data
            List<CartProduct> list = parseData(response.body);

            //Parse the links and meta data for UI

            // Parse the JSON string into a Map
            Map<String, dynamic> jsonMap = jsonDecode(response.body);

            //debugPrint(response.body);

            return list;
          } else {
            // Change the return type to indicate that the function may return a null value.
            return null;
          }
        } else {
          // Throw an exception if the response is null.
          throw Exception('Error');
        }
      } else {
        // Throw an exception if the streamedResponse is null.
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Read Json string and return a list of CartProduct objects.
  //Return type is a list of objects of the type CartProduct. This is a static class function, no need to create instance
  static List<CartProduct> parseData(String responseBody) {
    // Decode the JSON response into a Dart object.
    final decodedResponse = json.decode(responseBody);

    // Get the data array from the decoded object.
    final dataArray = decodedResponse['data'] as List<dynamic>;

    // Parse the data array into a list of ApiProduct objects and return
    final parsed = dataArray.cast<Map<String, dynamic>>();
    return parsed
        .map<CartProduct>((json) => CartProduct.fromJson(json))
        .toList();
  }

  @override
  //On wiget ini, getProducts function returns a future object and uses the then method to add a callback to update the list variable.
  void initState() {
    super.initState();
    getProducts("").then((ApiProductFromServer) {
      if (ApiProductFromServer != null) {
        setState(() {
          productList = ApiProductFromServer;
          //_totalResults = productList.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Shopping Cart'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(5),
                itemCount: productList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle the click event here
                      //RouteStateScope.of(context).go('/product/0');
                      RouteStateScope.of(context)
                          .go('/apiproduct/${productList[index].item_number}');
                      //or try /apiproduct/:item_number
                      //print('Card ${productList[index].item_number} clicked!');
                    },
                    child: Card(
                      surfaceTintColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: 0), //card padding
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: Image.network(
                                  productList[index].image_urls[0],
                                  //productList[index].image_urls, //was a string, now a list.
                                  //'https://images.bwicompanies.com/DA05TREES.jpg', //if hardcode
                                  //width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 20, 15),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productList[index].item_description,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        productList[index].item_number,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '\$${productList[index].price}',
                                        //If price is returned as a double convert to string and format to 2 decimal places.
                                        //'\$${productList[index].price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.green),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
}
