import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart'; //ie. var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
import '../auth.dart';

import '../data.dart';
import '../routing.dart';
//import '../widgets/product_search_delegate.dart';

import 'dart:async'; //optional but helps with debugging
import 'dart:convert'; //to and from json
import 'package:http/http.dart' as http; //for api requests

class ProductsBBScreen extends StatefulWidget {
  final String? filter; //To use: widget.contract_number

  const ProductsBBScreen({super.key, this.filter});

  @override
  State<ProductsBBScreen> createState() => _ProductsBBScreenState();
}

class _ProductsBBScreenState extends State<ProductsBBScreen> {
  //Defaults for pagination. The response will contain meta with current_page, from, path, per_page, and to. Page 1 will be from 1 to 10. Page 2 will be from 11 to 20.
  int _page = 1;
  var _prev = null;
  var _next = null;
  var _pageMessage = "";

  //Product list will be a List/Array where each element is a Map<String, dynamic>
  List<Map<String, dynamic>> productList = [];

  //Get the promo items from the API
  Future<List<Map<String, dynamic>>?> getProducts() async {
    final token = await ProductstoreAuth().getToken();
    final filter = widget.filter ?? ''; //grower

    //print(token);
    //print("getProducts filter");
    //print(filter);
    //print(widget.filter);

    http.Request request = http.Request(
        'GET',
        Uri.parse(ApiConstants.baseUrl +
            ApiConstants.bbEndpoint +
            '/?filter=$filter&page=$_page'));

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'application/json'; //Format sending
    request.headers['ACCEPT'] = 'application/json'; //Format recieving

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      //print(response.statusCode);

      //Parse response
      if (response.statusCode == 200) {
        //Contains the data, meta, and links lists/arrays
        Map<String, dynamic> jsonMap = jsonDecode(response.body);

        //Create the apiLinks object using the factory method
        ApiLinks apiLinks = ApiLinks.fromJson(jsonMap);

        _prev = apiLinks.prev;
        _next = apiLinks.next;

        _pageMessage = "Page $_page";

        //Loop through the items in the data array
        /*
            for (var item in jsonMap['data']) {
              print(item['id']);
            }
            */

        //convert jsonMap['data'] to a List where each element is a Map<String, dynamic>
        return List<Map<String, dynamic>>.from(jsonMap['data']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveFrom(filter) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('from', "/products_bb/$filter");
  }

  @override
  //On wiget ini, getProducts function returns a future object and uses the then method to add a callback to update the list variable.
  void initState() {
    super.initState();

    getProducts().then((ResultsFromServer) {
      if (ResultsFromServer != null) {
        setState(() {
          productList = ResultsFromServer;
        });
      }
    });

    saveFrom(widget.filter);
  }

  //Main Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bargain Barn'),
        actions: [
          IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                RouteStateScope.of(context).go('/promos');
              }),
          IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                RouteStateScope.of(context).go('/cart');
              }),
        ], //for i
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
                    RouteStateScope.of(context).go(
                        '/apiproduct/${productList[index]['bwiItem']['item_number']}');
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
                                productList[index]['bwiItem']['image_urls'][0],
                                height: 80,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 20, 15),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productList[index]['bwiItem']
                                          ['item_description'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      productList[index]['bwiItem']
                                          ['item_number'],
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey[600]),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '\$${productList[index]['price']}',
                                      //If price is returned as a double convert to string and format to 2 decimal places.
                                      //'\$${productList[index]['bwiItem'].price.toStringAsFixed(2)}',
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
                        onPressed: _prev == null
                            ? null
                            : () {
                                //can be pressed (Otherwise gray out)
                                // now that we disable the button if _prev is null, we can update the page number and update the productList.
                                if (_prev != null) {
                                  setState(() {
                                    _page = _page - 1;
                                  });

                                  getProducts().then((ResultsFromServer) {
                                    if (ResultsFromServer != null) {
                                      setState(() {
                                        productList = ResultsFromServer;
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
                      _pageMessage,
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
                        onPressed: _next == null
                            ? null
                            : () {
                                // now that we disable the button if _next is null, we can update the page number and update the productList.
                                if (_next != null) {
                                  setState(() {
                                    _page = _page + 1;
                                  });

                                  getProducts().then((ResultsFromServer) {
                                    if (ResultsFromServer != null) {
                                      setState(() {
                                        productList = ResultsFromServer;
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
    );
  }
}
