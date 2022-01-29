import 'package:flutter/material.dart';
import '../models/http_exp.dart';

import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {
  String _token;
  DateTime _exTime;
  String _userID;
  Timer _authTimer;

  BuildContext context;

  bool get isAuth {
    return _token != null;
    notifyListeners();
  }

  String get token {
    if (_exTime != null && _exTime.isAfter(DateTime.now()) && _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String get userID {
    return _userID;
  }

  Future<void> _call(String email, String password, String urls) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urls?key=AIzaSyDDq7VrjlKYiADt21yuK9D3z46Tq58IX1M';
    try {
      final res = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email.toString(),
          'password': password.toString(),
          'returnSecureToken': true,
        }),
      );

      final resData = json.decode(res.body);
      if (resData['error'] != null) {
        throw HttpExp(resData['error']['message']);
      }
      _token = resData['idToken'];
      _userID = resData['localId'];
      _exTime = DateTime.now()
          .add(Duration(seconds: int.parse(resData["expiresIn"])));
      _autologout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      String userData = json.encode({
        'token': _token,
        'userId': _userID,
        'expiryDate': _exTime.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _call(email, password, 'signUp');
  }

  Future<void> logIn(
    String email,
    String password,
  ) async {
    _token = null;

    return _call(email, password, "signInWithPassword").whenComplete(() {
      if (token != null) {}
    });
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final Map<String, Object> extData = json.decode(
        prefs.getString('userData') as String); //as Map<String, Object>;
    final expiryDate = DateTime.parse(extData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) return false;
    _token = extData['token'] as String;
    _userID = extData['userId'] as String;
    _exTime = expiryDate; //as DateTime;
    notifyListeners();
    _autologout();
    return true;
  }

  Future<void> logout() async {
    _token = null;

    _userID = null;
    _exTime = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null as Timer;
    }
    final pref = await SharedPreferences.getInstance();
    pref.clear();

    notifyListeners();
  }

  Future<void> _autologout() async {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _exTime.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  
}
