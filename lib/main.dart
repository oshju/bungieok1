

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/spotify_oauth2_client.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class hola extends StatelessWidget {

  final List<String> images = [
    'https://www.bungie.net/common/destiny2_content/icons/2c14244c0b840eaa09a8cf02b9e3c3bc.png',
    'https://www.bungie.net/common/destiny2_content/icons/132f8d399df9b04b80c3190de7d0b36c.png',
    'https://www.bungie.net/common/destiny2_content/icons/16fca06e91bb586a6b0e722f61dfc42b.png',
    'https://www.bungie.net/common/destiny2_content/icons/5f607ea5d6a5a3b32f6b2cbe5b11d9de.png',
    'https://www.bungie.net/common/destiny2_content/icons/3ca35f2f2d94ff2b2b62eef91d0b6a0f.png',
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
              ElevatedButton(onPressed: () async{
                final dio = Dio();
                dio.options.headers['x-api-key'] = '3028328cf7734aecb7217b2843daa5f0';
                dio.options.headers['Authorization'] = 'Bearer ${await getToken()}';
                dio.options.headers['Content-Type'] = 'application/json';
                dio.options.headers['Cookie'] = 'bungleanon=sv=BAAAAAA8IwAAAAAAAAtIIQAAAAAAYtxIAAAAAADeePDqSObZCEAAAACktJr93mkUhzaEbhqaYbIVvPUtq7i5pGiIqsLSjfrQjoo1bYngjlIU+47oq420u+ztQg9MWSQ9lMbW/gRXe/yW&cl=MC45MDIwLjIxODExMzE=; bungled=5905443050845129268; bungledid=BwFIvlwxiy9Jl6MoTFwf2yDeePDqSObZCAAA';

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
              }, child: Text('transfer to cazador')),
              CarouselSlider(
                items: [
                  Image.network('https://via.placeholder.com/350x150'),
                  Image.network('https://via.placeholder.com/350x150'),
                  Image.network('https://via.placeholder.com/350x150'),
                ],
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 16/9,
                  enlargeCenterPage: true,
                ),
              ),

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
Future<String?> getToken() async{
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



String token= tknResp.accessToken.toString();
return token;
}