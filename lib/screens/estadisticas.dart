import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:folderdocker/main.dart';
import 'package:http/http.dart' as http;

import '';



class estads extends StatefulWidget{
  @override
  _MiWidgetState createState() => _MiWidgetState();
}

class _MiWidgetState extends State<estads> {
  @override
  void initState() {
    super.initState();
    printtransferandread();
  }

    Future<void> printtransferandread() async {
    List<dynamic> lista;

    String? token= await getToken();

    var request= await http.Request(
      'GET',
        Uri.parse('https://www.bungie.net/Platform//Destiny2/1/Account/ 4611686018429892101/Character/2305843009260605642/Stats/'
    ));

    request.headers.addAll({
      'X-API-Key': '3028328cf7734aecb7217b2843daa5f0',
      'Content-Type': "application/json",
    });

    http.StreamedResponse response =
    await request.send().timeout(const Duration(seconds: 20));
    Map<String, dynamic>? userMap =
    jsonDecode(await response.stream.bytesToString());
    //['Response']['allPvP']['allTime']['kills']['basic']['value'];
    print(userMap?['Response']);
    print(userMap?['Response']?['allPvP']);
    print('hola');
    print(userMap?['Response']?['allPvP']);
    print(userMap?['Response']?['allPvP']);
    userMap?['Response']['allPvP']['allTime']['kills']['basic']['value'];
    print(userMap?['Response']['allPvP']['allTime']['kills']['basic']['value']);





  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
