import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folderdocker/screens/segundapantalla.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/spotify_oauth2_client.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:folderdocker/folderes/transerencia.dart';




class hola extends StatelessWidget {
  final List<String> images = [
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=9',
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.network(
                'https://picsum.photos/250?image=9',
                width: 250,
                height: 250,
              ),
              ElevatedButton(
                onPressed: () async {
                  String? token = await getToken();
                  print(token);
                },
                child: Text('hola'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final dio = Dio();
                    dio.options.headers['x-api-key'] =
                        '3028328cf7734aecb7217b2843daa5f0';
                    dio.options.headers['Authorization'] =
                        'Bearer ${await getToken()}';
                    dio.options.headers['Content-Type'] = 'application/json';
                    dio.options.headers['Cookie'] =
                        'bungleanon=sv=BAAAAAA8IwAAAAAAAAtIIQAAAAAAYtxIAAAAAADeePDqSObZCEAAAACktJr93mkUhzaEbhqaYbIVvPUtq7i5pGiIqsLSjfrQjoo1bYngjlIU+47oq420u+ztQg9MWSQ9lMbW/gRXe/yW&cl=MC45MDIwLjIxODExMzE=; bungled=5905443050845129268; bungledid=BwFIvlwxiy9Jl6MoTFwf2yDeePDqSObZCAAA';

                    try {
                      final response = await dio.post(
                        'https://www.bungie.net/Platform/Destiny2/Actions/Items/TransferItem/',
                        data: {
                          "itemReferenceHash": 1532276803,
                          "itemId": "6917529851458378851",
                          "stackSize": 1,
                          "transferToVault": false,
                          "characterId": "2305843009260605642",
                          "membershipType": 1
                        },
                      );
                      print(response.data);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text('transfer to cazador')),
              ElevatedButton(
                child: Text('Bungie screen'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TransferenciaScreen()),
                  );
                },
              ),

              CarouselSlider(
                items: [
                  Image.network('https://via.placeholder.com/350x150'),
                  Image.network('https://via.placeholder.com/350x150'),
                  Image.network('https://via.placeholder.com/350x150'),
                ],
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                ),
              ),
              Flexible(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Image.network(images[index]);
                      }))
            ],
          ),
        ),
      ),
    );
  }
}

main() {
  runApp(MaterialApp(
    home: hola(),
  ));
}

Future<String?> getToken() async {
  var client = OAuth2Client(
      authorizeUrl: "https://www.bungie.net/en/OAuth/Authorize",
      tokenUrl: "https://www.bungie.net/platform/app/oauth/token/",
      redirectUri: "com.example.ui:/",
      customUriScheme: 'com.example.ui');

  var tknResp = await client.getTokenWithAuthCodeFlow(
    clientId: "37130",
  );

  print(tknResp.httpStatusCode);
  print(tknResp.error);
  print(tknResp.expirationDate);
  print(tknResp.scope);

  String token = tknResp.accessToken.toString();
  print (token);
  return token;
}
/*
Future<List<dynamic>> calltoappi() async {
  var request = await http.Request(
      'GET',
      Uri.parse(
          'https://www.bungie.net/Platform/Destiny2/1/Profile/4611686018429892101/Character/2305843009260605642/?components=200,201,202,203,204,205,300,301'));

  request.headers.addAll({
    'X-API-Key': '3028328cf7734aecb7217b2843daa5f0'
  });

  http.StreamedResponse response =
      await request.send().timeout(const Duration(seconds: 20));
  Map<String, dynamic> userMap =
      jsonDecode(await response.stream.bytesToString());
  List<dynamic> userMap1 = userMap['Response']['equipment']['data']['items'];
  /*
  for (var i = 0; i < userMap1.length; i++) {
    print(userMap1[i]['Response']['equipment']['data']['items']);
  }

   */
  //var nos=tknResp.accessToken?.toString();

  //List<dynamic> userMap2 = userMap1['track']['preview_url'];
  //return userMap1.map((e) => Tracks1.fromJson(e)).toList();
  print(userMap1);
  return userMap1;
}

 */
Future<List<String>> calltoapi1() async {
  // Realizar solicitud HTTP para obtener la lista de hashes
  var request = await http.Request(
      'GET',
      Uri.parse(
          'https://www.bungie.net/Platform/Destiny2/1/Profile/4611686018429892101/Character/2305843009260605642/?components=200,201,202,203,204,205,300,301'));

  request.headers.addAll({
    'X-API-Key': '3028328cf7734aecb7217b2843daa5f0'
  });

  http.StreamedResponse response =
  await request.send().timeout(const Duration(seconds: 20));
  Map<String, dynamic> userMap =
  jsonDecode(await response.stream.bytesToString());
  List<dynamic> itemList = userMap['Response']['equipment']['data']['items'];

  // Crear una lista para almacenar los nombres de las armas
  List<String> itemNames = [];

  // Realizar una solicitud HTTP para obtener el nombre de cada arma
  for (var i = 0; i < itemList.length; i++) {
    var itemHash = itemList[i]['itemHash'].toString();
    var itemRequest = await http.Request(
        'GET',
        Uri.parse(
            'https://www.bungie.net/Platform/Destiny2/Manifest/DestinyInventoryItemDefinition/$itemHash'));

    itemRequest.headers.addAll({
      'X-API-Key': '3028328cf7734aecb7217b2843daa5f0'
    });

    http.StreamedResponse itemResponse =
    await itemRequest.send().timeout(const Duration(seconds: 20));
    Map<String, dynamic> itemMap =
    jsonDecode(await itemResponse.stream.bytesToString());
    var itemName = itemMap['Response']['displayProperties']['name'];
    itemNames.add(itemName);
  }

  // Devolver la lista de nombres de las armas
  return itemNames;
}




