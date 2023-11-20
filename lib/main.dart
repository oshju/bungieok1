import 'dart:async';
import 'dart:convert';


import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:folderdocker/folderes/credentials.dart';
import 'package:folderdocker/folderes/panmiercoles.dart';
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
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';






import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

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
    'opcion 4',
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
                else if(_selectedOption=='opcion 4'){
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                  //subir();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => appwrite()));
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

Future<String?> getBearer() async {
  // Define la URL del punto de autorización proporcionada por el servidor de autorización OAuth2.
  final authorizationEndpoint = Uri.parse("https://www.bungie.net/en/OAuth/Authorize");

  // El estándar OAuth2 espera que se envíe el identificador y el secreto del cliente
  // al usar la concesión de credenciales del cliente. Asegúrate de proporcionar
  // tanto el identificador del cliente como el secreto del cliente.
  final identifier = '37130';
  final secret = '';
  final apikey= "3028328cf7734aecb7217b2843daa5f0";

  // Llama a la función `clientCredentialsGrant` del nivel superior para obtener un cliente.
  final client = await oauth2.clientCredentialsGrant(authorizationEndpoint, identifier, secret);

  // Realiza la solicitud inicial
  final tokenResponse = await client.get(authorizationEndpoint);

  if (tokenResponse.statusCode == 302) {
    // La respuesta es una redirección, obtén la ubicación de redirección
    final redirectLocation = tokenResponse.headers['location'];
    if (redirectLocation != null) {
      // Sigue la redirección
      final response = await client.get(Uri.parse(redirectLocation));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Procesa la respuesta JSON de la API aquí
        return data;
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    }
  } else if (tokenResponse.statusCode == 200) {
    final data = json.decode(tokenResponse.body);
    print(data);
    // Procesa la respuesta JSON de la API aquí
    return data;
  } else {
    print('Error: ${tokenResponse.reasonPhrase}');
  }

  // También puedes obtener el token de acceso si lo necesitas.
  final accessToken = client.credentials.accessToken;
  print('Access Token: $accessToken');

  return accessToken;
}




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




PickedFile? pickedFile;

Future<void> chooseImage() async {
  pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
}



Future <Map<String, dynamic>> busca() async {
// Replace with your API key
  String apiKey = "3028328cf7734aecb7217b2843daa5f0";

  // Replace with the platform and display name of the player you want to search
  int membershipType = 1; // Xbox
  String displayName = "draxthegod";

  String url = "https://www.bungie.net/Platform/Destiny2/SearchDestinyPlayerByBungieName/$membershipType/$displayName";

  // Define the request body with the player's name
  Map<String, String> requestBody = {
    "bungieName": displayName,
  };

  Map<String, String> headers = {
    "X-API-Key": apiKey,
    "Content-Type": "application/json",
  };

  // Send the POST request
  http.post(
    Uri.parse(url),
    headers: headers,
    body: json.encode(requestBody),
  ).then((response) {
    if (response.statusCode == 200) {
      // Parse the response JSON to get the Destiny Membership ID
      Map<String, dynamic> responseBody = json.decode(response.body);
      // Your code for parsing JSON and extracting the Destiny Membership ID goes here
      print("Response: $responseBody");
    } else {
      print("Request failed with status: ${response.statusCode}");
    }


  }).catchError((error) {
    print("Error: $error");
  });
  return requestBody;
}

//appwrite subir imagen

Future<Map<dynamic, String>> subir() async {
  try {
    // Configurar el cliente Appwrite
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1') // Reemplaza con tu URL de Appwrite
        .setProject('6550c358e8cde42e540e');
    // Eliminar en producción

    // Crear una cuenta y obtener una sesión
    final account = Account(client);
    await account.create(
       userId: 'john_user_id',
       email: 'me@appwrite.io',
       password: 'password12',
       name: 'My Name',
     );
    //await account.createAnonymousSession();
    await account.createEmailSession(email: 'me@appwrite.io', password: 'password12');

    // Obtener el perfil del usuario
    await account.get();

    // Subir un archivo a Appwrite Storage
    final storage = Storage(client);

    late InputFile file;

    if (!kIsWeb) {
      final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        file = InputFile(bytes: bytes, filename: 'image.jpg');
      } else {
        throw Exception('No se seleccionó ninguna imagen.');
      }
    } else {
      file = InputFile(path: './path-to-file/image.jpg', filename: 'image.jpg');
    }

    final response = await storage.createFile(
      bucketId: '65536aa00c7851cfe299',
      file: file,
      permissions: [
        Permission.read(Role.any()),
      ], fileId: '',
    );

    print(response); // Archivo subido con éxito!

    return {'status': 'success'};
    
  } catch (e) {
    print('Error: $e');
    return {'status': 'error'};
  }
}






