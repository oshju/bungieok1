import 'dart:convert';
import 'package:folderdocker/main.dart';
import 'package:http/http.dart' as http;

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

Future<List<Transferencia>> calltoapi() async {
  String? token = await getToken();
  List characterEquipment = [];

  // Realizar solicitud HTTP para obtener la lista de hashes
  var request = await http.Request(
      'GET',
      Uri.parse(
          'https://www.bungie.net/Platform/Destiny2/1/Profile/4611686018429892101/?components=100,102,103,104,200,201,202,204,205,300,301,302,303,304,305,306,307,308,309,310,700,800,900,1000,1100,1200,1400'));

  request.headers.addAll({
    'Authorization': 'Bearer ${token ?? ''}',
    'X-API-Key': '3028328cf7734aecb7217b2843daa5f0',
    'Content-Type': "application/json",
  });

  http.StreamedResponse response =
  await request.send().timeout(const Duration(seconds: 20));
  Map<String, dynamic>? userMap =
  jsonDecode(await response.stream.bytesToString());
  print(userMap?['Response']);
  print(userMap?['Response']?['characterInventories']);
  print('hola');
  print(userMap?['Response']?['characterInventories']);
  print(userMap?['Response']?['characterInventories'].runtimeType);
// print(userMap['Response']['characterEquipment']['data']['items'].runtimeType);
// Obtener la lista de armas equipadas

  if (userMap?['Response'] != null &&
      userMap?['Response']?['characterInventories'] != null) {
    dynamic characterEquipment = userMap?['Response']?['characterInventories'];
    print(characterEquipment);
    List<dynamic> equippedItems = [];
    List<dynamic> unequippedItems = [];
    characterEquipment?['data']?['2305843009260605642']?['items']?.forEach((
        item) {
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

    // Recorrer la lista completa de items en tu inventario
    for (var i = 0; i < unequippedItems.length; i++) {
      print(unequippedItems[i]);
      // Obtener el hash y el id del item
      var itemHash = unequippedItems[i]['itemHash'].toString();
      var itemInstanceId = (unequippedItems[i]['itemInstanceId'].toString());
      var nombre = unequippedItems[i]['itemName'].toString();
      String icon = 'https://www.bungie.net/${unequippedItems[i]['icon']}';
      if (unequippedItems[i]['icon'] == null) {
        icon = "https://www.bungie.net/common/destiny2_content/icons/7a1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b.png";
        print('nulo');
      }
      transferencias.add(Transferencia(
        itemName: itemHash,
        characterId: '2305843009260605642',
        itemInstanceId: itemInstanceId,
        membershipType: 1,
        itemReferenceHash: int.parse(itemHash),
        stackSize: 1,
        transferToVault: true,
        icon: icon,
      ));

      // Verificar si el item es un arma
      var itemType = unequippedItems[i]['itemType'].toString();


      // Verificar si el item está equipado
      // Verificar si el item está equipado

      var itemRequest = await http.Request(
          'GET',
          Uri.parse(
              'https://www.bungie.net/Platform/Destiny2/Manifest/DestinyInventoryItemDefinition/$itemHash'));

      itemRequest.headers
          .addAll({'X-API-Key': '3028328cf7734aecb7217b2843daa5f0'});
      http.StreamedResponse itemResponse =
      await itemRequest.send().timeout(const Duration(seconds: 20));
      Map<String, dynamic> itemMap =
      jsonDecode(await itemResponse.stream.bytesToString());
      var itemName = itemMap['Response']['displayProperties']['name'];
      var itemIcon = itemMap['Response']['displayProperties']['icon'].toString();
      transferencias.add(Transferencia(
        itemName: itemName,
        itemInstanceId: itemInstanceId,
        characterId: '2305843009260605642',
        membershipType: 1,
        itemReferenceHash: int.parse(itemHash),
        stackSize: 1,
        transferToVault: true,
        icon: itemIcon,

      ));
    }

// Devolver la lista de armas que no están equipadas
    return transferencias;
  } else {
    print('No se encontraron armas no equipadas');
    return [];
  }
}









    // Obtener la lista completa de armas en tu inventario
  /*
  List<dynamic> itemList =
      userMap['Response']['characterEquipmnet']['data']['2305843009260605640']['items'];
  if (itemList == null) {
    print('lista nula');
  }
  */

  // Crear una lista para almacenar las armas que no están equipadas


Future<String> transferItem(
    Transferencia transferencia,
    String characterId,
    String itemInstanceId,
    int membershipType,
    int itemReferenceHash,
    int stackSize,
    bool transferToVault,
    String itemName) async {
  String? token = await getToken();
  var request = http.Request(
      'POST',
      Uri.parse(
          'https://www.bungie.net/Platform/Destiny2/Actions/Items/TransferItem/'));
           https://www.bungie.net/Platform/Destiny2/Actions/Items/TransferItem/

  request.headers.addAll({
    'Authorization': 'Bearer ${token ?? ''}',
    'X-API-Key': '3028328cf7734aecb7217b2843daa5f0',
    'Content-Type': 'application/json',
    'Cookie': 'bungleanon=sv=BAAAAAA8IwAAAAAAAAtIIQAAAAAAYtxIAAAAAADeePDqSObZCEAAAACktJr93mkUhzaEbhqaYbIVvPUtq7i5pGiIqsLSjfrQjoo1bYngjlIU+47oq420u+ztQg9MWSQ9lMbW/gRXe/yW&cl=MC45MDIwLjIxODExMzE=; bungled=5905443050845129268; bungledid=BwFIvlwxiy9Jl6MoTFwf2yDeePDqSObZCAAA'
  });

  request.body = jsonEncode({
    'itemReferenceHash': transferencia.itemReferenceHash,
    'itemId': transferencia.itemInstanceId,
    'stackSize': transferencia.stackSize,
    'transferToVault': true,
    'characterId': transferencia.characterId,
    'membershipType': transferencia.membershipType,
  });

  http.Response response = await http.Response.fromStream(await request.send());
  print(response.body);

  if (response.statusCode == 200) {
    return "Transfer successful!"; // no se usa la cantidad de items para esta versión
  } else {
    return "Transfer failed!";
  }
}
