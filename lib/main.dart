import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folderdocker/folderes/postmaster.dart';
import 'package:folderdocker/folderes/vendors.dart';
import 'package:folderdocker/screens/animationes.dart';
import 'package:folderdocker/screens/manifest.dart';
import 'package:folderdocker/screens/segundapantalla.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/spotify_oauth2_client.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:folderdocker/folderes/transerencia.dart';




import 'package:flutter/material.dart';

class hola extends StatefulWidget {
  @override
  _holaState createState() => _holaState();
}

class _holaState extends State<hola> {
  String? _selectedOption;

  final List<String> _dropdownOptions = [
    'Bungie transferencias',
    'Bungie postmaster',
    'Opción 3',
  ];

  final List<String> _images = [
    'https://media.game.es/COVERV2/3D_L/159/159317.png',
    'https://static-00.iconduck.com/assets.00/destiny-icon-512x475-qi0g8ih3.png',
    'https://picsum.photos/250?image=9',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación'),
        backgroundColor: Colors.blueGrey[900],
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.network(
                'https://picsum.photos/250?image=9',
                width: 250,
                height: 250,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedOption,
                items: _dropdownOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue;
                  });

                },
                decoration: InputDecoration(
                  labelText: 'Selecciona una opción',
                  border: OutlineInputBorder(),
                ),
              ),
            ElevatedButton(
              onPressed: () async {
                if (_selectedOption == 'Bungie transferencias') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => transferenciaWidget()));
                } else if (_selectedOption == 'Bungie postmaster') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TransferenciaScreen()));
                } else if (_selectedOption == 'Opción 3') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VendorsApp()));
                }
              },
              child: Text('Navegar a la pantalla seleccionada'),
            ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String? token = await getToken();
                  print(token);
                },
                child: Text('Obtener Token'),
              ),
              SizedBox(height: 20),
              // Primer carrusel
              CarouselSlider(
                items: _images.map((image) {
                  return Image.network(image);
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                ),
              ),
              SizedBox(height: 20),
              // Segundo carrusel
              CarouselSlider(
                items: _images.map((image) {
                  return Image.network(image);
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                ),
              ),
              SizedBox(height: 20),
              // Widget Wrap para mostrar imágenes
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: _images.map((image) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }).toList(),
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




