import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../folderes/transerencia.dart';
import '../main.dart';

class TransferenciaWidget extends StatefulWidget {
  @override
  _TransferenciaWidgetState createState() => _TransferenciaWidgetState();
}

class Transferencia {
  final String itemName;
  final String itemInstanceId;
  final String characterId;
  final int membershipType;
  final int itemReferenceHash;
  final int stackSize;
  final bool transferToVault;
  final String? icon;

  Transferencia({
    required this.itemName,
    required this.itemInstanceId,
    required this.characterId,
    required this.membershipType,
    required this.itemReferenceHash,
    required this.stackSize,
    required this.icon,
    this.transferToVault=true,
  });
}

class _TransferenciaWidgetState extends State<TransferenciaWidget> {
  late Future<List<Transferencia>> _transferencias;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transferencia'),
      ),
      body: Center(
        child: FutureBuilder<List<Transferencia>>(
          future: _transferencias,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].itemName),
                    subtitle: Text(snapshot.data![index].itemInstanceId),
                    leading: Image.network(snapshot.data![index].icon!),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
  Future<List<Transferencia>>? calltoapi() async {
    String? token = await getToken();
    List<dynamic> characterEquipment = [];

    // Realizar solicitud HTTP para obtener la lista de hashes
    var request = await http.Request(
      'GET',
      Uri.parse(
          'https://www.bungie.net/Platform/Destiny2/1/Profile/4611686018429892101/?components=100,102,103,104,200,201,202,204,205,300,301,302,303,304,305,306,307,308,309,310,700,800,900,1000,1100,1200,1400'),
    );

    request.headers.addAll({
      'Authorization': 'Bearer ${token ?? ''}',
      'X-API-Key': '3028328cf7734aecb7217b2843daa5f0',
      'Content-Type': "application/json",
    });

    http.StreamedResponse response = await request.send().timeout(
        const Duration(seconds: 20));
    Map<String, dynamic>? userMap = jsonDecode(
        await response.stream.bytesToString());
    print(userMap?['Response']);
    print(userMap?['Response']?['characterInventories']);
    print('hola');
    print(userMap?['Response']?['characterInventories']);
    print(userMap?['Response']?['characterInventories'].runtimeType);

    // Obtener la lista de armas equipadas
    if (userMap?['Response'] != null &&
        userMap?['Response']?['characterInventories'] != null) {
      characterEquipment =
          characterEquipment = userMap?['Response']?['characterInventories']?['data']?['2305843009260605642']?['items'] ?? [];

      [];
      print(characterEquipment);
      List<dynamic> equippedItems = [];
      List<dynamic> unequippedItems = [];
      characterEquipment.forEach((item) {
        if (item?['isEquipped'] == true) {
          print('entro');
          equippedItems.add(item);
        } else {
          print('entro en armas no equipadas!');
          unequippedItems.add(item);
        }
      });

      // hacer algo con equippedItems y unequippedItems...
      List<Transferencia> transferencias = [];

      void printUnequippedItems(List<Map<String, dynamic>> unequippedItems) {
        for (var i = 0; i < unequippedItems.length; i++) {
          print(unequippedItems[i]);
          // Obtener el hash y el id del item
          var itemHash;
          void printUnequippedItems(
              List<Map<String, dynamic>> unequippedItems) {
            for (var i = 0; i < unequippedItems.length; i++) {
              print(unequippedItems[i]);
              // Obtener el hash y el id del item
              var itemHash = unequippedItems[i]['itemHash'].toString();
              var itemId = unequippedItems[i]['itemId'].toString();
              print('Hash del item: $itemHash');
              print('ID del item: $itemId');

              // Crear una nueva transferencia
              var transferencia = Transferencia(
                itemName: unequippedItems[i]['item']['displayProperties']['name'],
                itemInstanceId: itemId,
                characterId: unequippedItems[i]['characterId'],
                membershipType: unequippedItems[i]['membershipType'],
                itemReferenceHash: unequippedItems[i]['itemHash'],
                stackSize: unequippedItems[i]['quantity'],
                icon: unequippedItems[i]['item']['displayProperties']['icon'],
              );

              return transferencias.add(transferencia);
            }
          }
        }
      }
    }
    return _transferencias;
  }
  //do a class to control statefullwidget
  @override
  void initState() {
    super.initState();
    _transferencias = calltoapi()!;

  }

  @override
  void dispose() {
    super.dispose();
  }




  }

