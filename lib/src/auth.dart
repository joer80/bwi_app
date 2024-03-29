import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import './constants.dart'; //ie. var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
import 'dart:convert';

class ProductstoreAuth extends ChangeNotifier {
  //Priviate class variables
  bool _signedIn = false;

  //List<String> accounts = ['EOTH076', 'TANB100', 'TACE500'];

  //getter methods to allow outside access to the private class variables
  bool get signedIn => _signedIn;
  //ie. _auth.signedIn or ProductstoreAuthScope.of(context).signedIn

  Future<bool> isTokenValid() async {
    String? currentToken = await this.getToken();

    //print(currentToken);

    //If token is there, see if it is valid
    if (currentToken != null) {
      //Make an authorized API call using the token to see if its valid
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $currentToken',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        //print('response is good');
        //debugPrint(response.body);
        _signedIn = true;
      } else {
        //print('response: ${response.statusCode}');
        _signedIn = false;
        //final prefs = await SharedPreferences.getInstance();
        //await prefs.clear();      }
      }
    } else {
      //Token is not there
      _signedIn = false;
    }

    return _signedIn;
  }

/*
  //If we want to use a package to check the expiration date of the token to save an api call if it is expired. But it calls api anyway if its still valid to confirm.
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      DateTime expirationDate = DateTime.parse(decodedToken['exp']);

      if (expirationDate.isBefore(DateTime.now())) {
        return false;
      }

      // Make an authorized API call using the token
      // If the API responds with a successful status code, the token is valid
      // If the API responds with an unauthorized status code, the token is invalid

      return true;
    } catch (e) {
      return false;
    }

  */

//Navigator runs .signIn when the user clicks the sign in button
  Future<bool> signIn(String email, String password) async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.authEndpoint);

    final response = await http.post(url, body: {
      'email': email,
      'password': password,
      //'type': 'mobile-app',
      //'device_name': '', //await getDeviceId(),
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      String token = response.body;
      //print(response.body);
      await saveToken(token);
      await saveUserData(token);
      _signedIn = true;
      notifyListeners();
      return true;
    } else {
      //print('Status code: ${response.statusCode}');
    }

    if (response.statusCode == 422) {
      _signedIn = false;
      return false;
    }

    return false;
  }
  //end sign in

  Future<void> signOut() async {
    _signedIn = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  saveUserData(String token) async {
    final prefs = await SharedPreferences.getInstance();

    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    //print(response);

    if (response.statusCode == 200) {
      //print(response.body);

      // Parse the JSON string and save to variable
      Map<String, dynamic> jsonData = json.decode(response.body);

      //Persist to local storage
      await prefs.setString('accountnum', jsonData['data']['accountnum']);
      await prefs.setString('activeaccount', jsonData['data']['activeaccount']);
      await prefs.setString('email', jsonData['data']['email']);
      await prefs.setInt('userid', jsonData['data']['id']);
      await prefs.setString('username', jsonData['data']['name']);
      await prefs.setString(
          'active_account_name', jsonData['data']['active_account_name']);
    } else {
      //print('Error: ${response.statusCode}');
      throw Exception('Problem loading user data');
    }
  }

  @override
  bool operator ==(Object other) =>
      other is ProductstoreAuth && other._signedIn == _signedIn;

  @override
  int get hashCode => _signedIn.hashCode;
}
//End ProductstoreAuth

class ProductstoreAuthScope extends InheritedNotifier<ProductstoreAuth> {
  const ProductstoreAuthScope({
    required super.notifier,
    required super.child,
    super.key,
  });

  static ProductstoreAuth of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ProductstoreAuthScope>()!
      .notifier!;
}
