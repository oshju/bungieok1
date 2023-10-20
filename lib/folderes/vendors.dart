import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

// Asegúrate de tener definida la función getToken aquí si es necesaria.

void main() {
  runApp(VendorsApp());
}

class VendorGroup {
  final int vendorGroupHash;
  final List<int> vendorHashes;

  VendorGroup({
    required this.vendorGroupHash,
    required this.vendorHashes,
  });

  factory VendorGroup.fromJson(Map<String, dynamic> json) {
    final List<int> vendorHashes =
    List<int>.from(json['vendorHashes'] ?? []);
    return VendorGroup(
      vendorGroupHash: json['vendorGroupHash'],
      vendorHashes: vendorHashes,
    );
  }
}

class Vendor {
  final bool canPurchase;
  final Progression progression;

  Vendor({
    required this.canPurchase,
    required this.progression,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      canPurchase: json['canPurchase'] ?? false,
      progression: Progression.fromJson(json['progression'] ?? {}),
    );
  }
}

class Progression {
  final int progressionHash;
  final int dailyProgress;
  final int dailyLimit;
  final int weeklyProgress;
  final int weeklyLimit;
  final int currentProgress;
  final int level;
  final int levelCap;
  final int stepIndex;
  final int progressToNextLevel;
  final int nextLevelAt;

  Progression({
    required this.progressionHash,
    required this.dailyProgress,
    required this.dailyLimit,
    required this.weeklyProgress,
    required this.weeklyLimit,
    required this.currentProgress,
    required this.level,
    required this.levelCap,
    required this.stepIndex,
    required this.progressToNextLevel,
    required this.nextLevelAt,
  });

  factory Progression.fromJson(Map<String, dynamic> json) {
    return Progression(
      progressionHash: json['progressionHash'] ?? 0,
      dailyProgress: json['dailyProgress'] ?? 0,
      dailyLimit: json['dailyLimit'] ?? 0,
      weeklyProgress: json['weeklyProgress'] ?? 0,
      weeklyLimit: json['weeklyLimit'] ?? 0,
      currentProgress: json['currentProgress'] ?? 0,
      level: json['level'] ?? 0,
      levelCap: json['levelCap'] ?? -1,
      stepIndex: json['stepIndex'] ?? 0,
      progressToNextLevel: json['progressToNextLevel'] ?? 0,
      nextLevelAt: json['nextLevelAt'] ?? 0,
    );
  }
}

class VendorsApp extends StatelessWidget {
  Future<List<VendorGroup>> fetchVendorGroups() async {
    String? token = await getToken();
    var request = await http.get(
      Uri.parse(
        'https://www.bungie.net/Platform/Destiny2/1/Profile/4611686018429892101/Character/2305843009260605642/Vendors/?components=300,301,304,305,306,307,308,310,400,401,402',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token ?? ''}',
        'X-API-Key': '3028328cf7734aecb7217b2843daa5f0',
      },
    );

    if (request.statusCode == 200) {
      // Obtiene la respuesta JSON como una cadena
      String jsonResponse = request.body;
      print(jsonResponse);

      // Limpia la cadena JSON eliminando caracteres inesperados
      jsonResponse = jsonResponse.replaceAll('<', '').replaceAll('…', '');

      // Decodifica la cadena JSON limpia
      final Map<String, dynamic> jsonData = json.decode(jsonResponse);

      // Continúa con el procesamiento de los datos decodificados
      final List<
          dynamic> groupsData = jsonData['Response']['vendorGroups']['data']['groups'] ??
          [];

      return parseVendorGroups(groupsData, jsonData);
    } else {
      throw Exception('Fallo al cargar los datos');
    }
  }

  Future<List<VendorGroup>> parseVendorGroups(List<dynamic> groupsData, Map<String, dynamic> jsonResponse) async {
    final List<VendorGroup> vendorGroups = [];
    String? token = await getToken();

    for (var groupData in groupsData) {
      vendorGroups.add(VendorGroup.fromJson(groupData));
    }
    print('Vendor Groups: $vendorGroups');

    // Accede a la clave "Response" en el JSON
    final Map<String, dynamic> responseData = jsonResponse['Response'];

    // Accede a la clave "vendors" en el JSON
    final Map<String, dynamic> vendorsData = responseData['vendors'];

    // Accede a la clave "data" en el JSON
    final Map<String, dynamic> data = vendorsData['data'];

    // Itera sobre todas las claves en "data" para acceder a los vendedores
    data.forEach((vendorKey, vendorData) async {
      // El valor de vendorKey será la clave del vendedor actual, por ejemplo, "396892126"

      // Puedes acceder a las propiedades específicas del vendedor de la siguiente manera:
      final bool canPurchase = vendorData['canPurchase'];
      final Map<String, dynamic>? progression = vendorData['progression'];
      if (progression != null) {
        if(vendorKey==672118013){
          var itemRequest = await http.Request(
            'GET',
            Uri.parse(
                'https://www.bungie.net/Platform/Destiny2/1/Profile/4611686018429892101/Character/2305843009260605642/Vendor/$vendorKey/?components=400,401,402,403'
            ),
          );

          itemRequest.headers.addAll({
            'X-API-Key': '3028328cf7734aecb7217b2843daa5f0',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token ?? ''}',
          });

          http.StreamedResponse itemResponse = await itemRequest.send().timeout(const Duration(seconds: 20));
          Map<String, dynamic> itemMap = jsonDecode(await itemResponse.stream.bytesToString());
          print(itemMap);

          Vendor;
        }
        final int progressionHash = progression['progressionHash'];
        final int dailyProgress = progression['dailyProgress'];
        final int dailyLimit = progression['dailyLimit'];

        // ... y así sucesivamente

        // Haz algo con estos datos, como imprimirlos
        print('Vendedor: $vendorKey');
        print('canPurchase: $canPurchase');
        print('progressionHash: $progressionHash');
        print('dailyProgress: $dailyProgress');
        print('dailyLimit: $dailyLimit');
      }

      // Aquí, dentro del bucle, puedes realizar la solicitud HTTP con el valor de vendorKey
      var itemRequest = await http.Request(
        'GET',
        Uri.parse(
            'https://www.bungie.net/Platform/Destiny2/1/Profile/4611686018429892101/Character/2305843009260605642/Vendor/$vendorKey/?components=400,401,402,403'
        ),
      );

      itemRequest.headers.addAll({
        'X-API-Key': '3028328cf7734aecb7217b2843daa5f0',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token ?? ''}',
      });

      http.StreamedResponse itemResponse = await itemRequest.send().timeout(const Duration(seconds: 20));
      Map<String, dynamic> itemMap = jsonDecode(await itemResponse.stream.bytesToString());
      print(itemMap);

      // Do something with itemMap if necessary
    });

    return vendorGroups;
  }











  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vendedores',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Vendedores'),
        ),
        body: Center(
          child: FutureBuilder<List<VendorGroup>>(
            future: fetchVendorGroups(),
            builder: (BuildContext context, AsyncSnapshot<List<VendorGroup>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No se encontraron datos de vendedores.');
              } else {
                final vendorGroups = snapshot.data;
                return ListView.builder(
                  itemCount: vendorGroups?.length,
                  itemBuilder: (context, index) {
                    final group = vendorGroups?[index];
                    return ListTile(
                      title: Text('Grupo de vendedores: ${group?.vendorGroupHash}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vendedores en este grupo:'),
                          if (group?.vendorHashes != null)
                            ...?group?.vendorHashes.map((vendorHash) {
                              return Text('- Vendor Hash: $vendorHash');
                            }),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}