// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../data/library.dart';
import '../routing.dart';
import '../widgets/product_search_delegate.dart';

class HomeScreen extends StatelessWidget {
  final String title = 'Home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          //title: Text(title),
          //centerTitle: true,
          title: Image.asset('assets/logo.png', height: 35),
          actions: [
            IconButton(
                onPressed: () {
                  RouteStateScope.of(context).go('/products');
                  /*
                  showSearch(
                      context: context,
                      delegate: ProductSearchDelegate() //(products: products)
                      );
                      */
                },
                icon: const Icon(Icons.search)),
            IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  RouteStateScope.of(context).go('/cart');
                }),
            IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  RouteStateScope.of(context).go('/account');
                }),
          ], //for icons on the right. ie. IconButton
          backgroundColor: Colors.green[700],
          //leading: Image.asset('assets/logo.png', width: 40, height: 40),
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 135, //175 might be better
                color: Colors.grey[200], // specify the color of the square
                margin: EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  'assets/AppBanner2024.png',
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    children: [
                      HomeCard(
                          Title: 'Catalog',
                          iData: Icons.auto_stories,
                          Route: '/products'),
                      HomeCard(
                          Title: 'Promotions',
                          iData: Icons.sell,
                          Route: '/promos'),
                      HomeCard(
                          Title: 'Scan Barcode',
                          iData: Icons.qr_code_scanner,
                          Route: '/scan'),

                      //HomeCard(Title: 'Track Order', iData: Icons.share_location, Route: '/track'),
                      //HomeCard(Title: 'Favorites', iData: Icons.favorite, Route: '/favorites'),
                      HomeCard(
                          Title: 'Order History',
                          iData: Icons.history,
                          Route: '/history'),
                      /*
                      HomeCard(
                          Title: 'My Account',
                          iData: Icons.account_box,
                          Route: '/account'),*/
                    ]),
              ),
            ],
          ),
        ),
      );
}

class HomeCard extends StatelessWidget {
  final String Title;
  final String Route;
  final IconData iData;

  const HomeCard(
      {required this.Title, required this.iData, required this.Route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        RouteStateScope.of(context).go(Route);
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
          side: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Icon(
                iData,
                color: Colors.green[700],
                size: 60,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                Title,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
