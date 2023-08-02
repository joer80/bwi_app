//Contains the main navigation routes for the app
//and uses adaptive_navigation.dart package
//Body is stored in scaffold_body.dart

import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';

import '../routing.dart';
import 'scaffold_body.dart';

class BookstoreScaffold extends StatelessWidget {
  const BookstoreScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final selectedIndex = _getSelectedIndex(routeState.route.pathTemplate);

    return Scaffold(
      body: AdaptiveNavigationScaffold(
        selectedIndex: selectedIndex,
        body: const BookstoreScaffoldBody(),
        //Main Nav Routes
        onDestinationSelected: (idx) {
          if (idx == 0) routeState.go('/home');
          if (idx == 1) routeState.go('/books/popular');
          if (idx == 2) routeState.go('/authors');
          if (idx == 3) routeState.go('/history');
          if (idx == 4) routeState.go('/settings');
        },
        destinations: const [
          AdaptiveScaffoldDestination(
            title: 'Home', //was books
            icon: Icons.home,
          ),
          AdaptiveScaffoldDestination(
            title: 'Catalog', //was authors
            icon: Icons.auto_stories,
          ),
          /*
          AdaptiveScaffoldDestination(
            title: 'Vendors',
            icon: Icons.person,
          ),
          */
          AdaptiveScaffoldDestination(
            title: 'Scan',
            icon: Icons.qr_code_scanner,
          ),
          AdaptiveScaffoldDestination(
            title: 'History',
            icon: Icons.history,
          ),
          AdaptiveScaffoldDestination(
            title: 'Account', //Was Settings
            icon: Icons.person, //was settings
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String pathTemplate) {
    if (pathTemplate == '/home') return 0;
    if (pathTemplate.startsWith('/books')) return 1;
    if (pathTemplate == '/authors') return 2;
    if (pathTemplate == '/history') return 3;
    if (pathTemplate == '/settings') return 4;
    return 0;
  }
}
