import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/global_variable.dart';

class AuthService {
  void signupUser({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      UserModel user = UserModel(
          id: '',
          name: name,
          email: email,
          password: password,
          type: '',
          address: '',
          token: '');

      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: (() {
            showSnackBar(context, 'Account Created');
          }));
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signinUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse('$uri/api/signin'),
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      httpErrorHandler(
          response: res,
          context: context,
          onSuccess: (() async {
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs
                .setString('x-auth-token', jsonDecode(res.body)['token'])
                .then((value) => print(context));
            // .then((value) => Navigator.pushNamedAndRemoveUntil(
            //     context, HomeScreen.routeName, (route) => false));
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);
          }));
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void getUser(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(Uri.parse('$uri/tokenIsVerified'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(Uri.parse('$uri/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            });

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
