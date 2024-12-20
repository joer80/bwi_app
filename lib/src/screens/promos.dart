// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import '../constants.dart'; //ie. var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
import 'package:http/http.dart' as http; //for api requests
import '../auth.dart';
import 'dart:convert'; //to and from json
import '../routing.dart';
import '../data.dart'; //used for meta and links classes

class PromoScreen extends StatefulWidget {
  const PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  //String _scanBarcode = '';
  final String title = 'Promotions';

  //Promo Variables
  List<Map<String, dynamic>> promoList = [];
  int _pageP = 1;
  var _prevP = null;
  var _nextP = null;
  var _pageMessageP = "";

  //Bargain Barn Variables
  Map<String, String> bbMap = {
    "grower": "Grower Items",
    "landscape": "Landscape Items",
    "pest": "Pest Items",
    "retail": "Retail Items",
    "other": "Other Items"
  };

  //Get the open orders from the API
  Future<List<Map<String, dynamic>>?> _getPromos() async {
    final token = await ProductstoreAuth().getToken();

    //print(token);

    http.Request request = http.Request(
        'GET',
        Uri.parse(ApiConstants.baseUrl +
            ApiConstants.promoEndpoint +
            '?page=$_pageP'));

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'application/json'; //Format sending
    request.headers['ACCEPT'] = 'application/json'; //Format recieving

    try {
      var streamedResponse = await request.send();
      if (streamedResponse != null) {
        var response = await http.Response.fromStream(streamedResponse);

        if (response != null) {
          //print(response.statusCode);

          //Parse response
          if (response.statusCode == 200) {
            //Contains the data, meta, and links lists/arrays
            Map<String, dynamic> jsonMap = jsonDecode(response.body);

            //Create the apiLinks object using the factory method
            ApiLinks apiLinks = ApiLinks.fromJson(jsonMap);

            //debugPrint(response.body);

            _prevP = apiLinks.prev;
            _nextP = apiLinks.next;
            //_page = metaData.current_page;

            _pageMessageP = "Page $_pageP";

            return List<Map<String, dynamic>>.from(jsonMap['data']);
          } else {
            return null;
          }
        } else {
          throw Exception('Error');
        }
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    //Populate the Promos tab
    _getPromos().then((ResultsFromServer) {
      if (ResultsFromServer != null) {
        setState(() {
          promoList = ResultsFromServer;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2, // Adjust the number of tabs based on your needs
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    RouteStateScope.of(context).go('/cart');
                  }),
            ],
            backgroundColor: Theme.of(context).colorScheme.primary,
            titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
            ),
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor:
                  Colors.white70, // Lighter shade for unselected tabs
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary, width: 4.0),
                insets: EdgeInsets.fromLTRB(
                    0.0, 0.0, 0.0, 2.0), // Adjust this to move the underline up
              ),
              //indicatorColor: Colors.green[900],
              tabs: [
                Tab(text: 'Current Promotions'),
                Tab(text: 'Bargain Barn'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Content for the Promos tab
              promoList.isEmpty
                  ? Text("") //No recent items
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.all(5),
                            itemCount: promoList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  // Handle the click event here
                                  //print("onclick"); //  /products_promo/OHPFALL24
                                  RouteStateScope.of(context).go(
                                      '/products_promo/${promoList[index]['contract_number']}');
                                },
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              25, 20, 25, 20),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  promoList[index]
                                                      ['promo_text'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                /* how to to regular non bold text
                                                SizedBox(height: 5),
                                                Text(
                                                  promoList[index]
                                                      ['promo_text'],
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color:
                                                          Colors.grey[600]),
                                                ),
                                                */
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        //add a separator and pagination under cards
                        //Divider(),
                        PreferredSize(
                          preferredSize: Size.fromHeight(58),
                          child: Container(
                              height: 58.0,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              //color: Colors.green[600],
                              child: Row(
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      color: Colors.grey[700],
                                      onPressed: _prevP == null
                                          ? null
                                          : () {
                                              //can be pressed (Otherwise gray out)
                                              // now that we disable the button if _prev is null, we can update the page number and update the productList.
                                              if (_prevP != null) {
                                                setState(() {
                                                  _pageP = _pageP - 1;
                                                });

                                                _getPromos()
                                                    .then((ResultsFromServer) {
                                                  if (ResultsFromServer !=
                                                      null) {
                                                    setState(() {
                                                      promoList =
                                                          ResultsFromServer;
                                                      //_totalResults = productList.length;
                                                    });
                                                  }
                                                });
                                              }
                                            },
                                    ),
                                  ),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    _pageMessageP,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[700],
                                    ),
                                  ))),
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_forward),
                                      color: Colors.grey[700],
                                      onPressed: _nextP == null
                                          ? null
                                          : () {
                                              // now that we disable the button if _next is null, we can update the page number and update the productList.
                                              if (_nextP != null) {
                                                setState(() {
                                                  _pageP = _pageP + 1;
                                                });

                                                _getPromos()
                                                    .then((ResultsFromServer) {
                                                  if (ResultsFromServer !=
                                                      null) {
                                                    setState(() {
                                                      promoList =
                                                          ResultsFromServer;
                                                      //_totalResults = productList.length;
                                                    });
                                                  }
                                                });
                                              }
                                            },
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
              // Content for the Bargain Barn tab
              bbMap.isEmpty
                  ? Text("") //No Open Orders
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.all(5),
                            itemCount: bbMap.length,
                            itemBuilder: (BuildContext context, int index) {
                              final key = bbMap.keys.elementAt(index);
                              final value = bbMap[key]!;
                              return GestureDetector(
                                onTap: () {
                                  // Handle the click event here
                                  //print("onclick $key"); //
                                  RouteStateScope.of(context)
                                      .go("/products_bb/$key");
                                },
                                child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          25, 20, 25, 20),
                                      child: Text(value,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600)),
                                    )),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ], //tab bar view children
          ), //tabbarview
        ), //body scaffold
      ); //build widget
}
