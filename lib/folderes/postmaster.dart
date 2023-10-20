import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../folderes/transerencia.dart';
import '../main.dart';

class transferenciaWidget extends StatefulWidget {

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

class _TransferenciaWidgetState extends State<transferenciaWidget> {
  late Future<List<Transferencia>> _transferencias = Future.value([]);
  List<dynamic> postmasterlist = [];
  _TransferenciaWidgetState() {
    postmaster(postmasterlist).then((nuevasTransferencias) {
      postmasterlist = nuevasTransferencias;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transferencias'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.network(
                'https://th.bing.com/th/id/R.ed07a00cdc182ac8b80b425726113ff2?rik=YekFTyQJWErntQ&pid=ImgRaw&r=0')
                .image,
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: _transferencias,
          builder: (BuildContext context,
              AsyncSnapshot<List<Transferencia>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: EdgeInsets.all(10),
                children: snapshot.data!.map((transferencia) {
                  return GestureDetector(
                    onTap: () async {
                      String result = await transferItem(
                          transferencia,
                          transferencia.characterId,
                          transferencia.itemInstanceId,
                          transferencia.membershipType,
                          transferencia.itemReferenceHash,
                          transferencia.stackSize,
                          transferencia.transferToVault,
                          transferencia.itemName);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(result)));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://www.bungie.net${transferencia.icon}',
                            height: 80,
                            width: 80,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 10),
                          Text(
                            transferencia.itemName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              return Center(
                child: Text("No hay datos disponibles"),
              );
            }
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
          userMap?['Response']?['characterInventories']?['data']?['2305843009260605642']?['items'] ?? [];

      print(characterEquipment);
      List<dynamic> equippedItems = [];
      List<dynamic> unequippedItems = [];
      List<dynamic> postmasterlist = [];

      characterEquipment.forEach((item) {
        if (item?['isEquipped'] != true) {
          print('entro');
          equippedItems.add(item);
          if (item.containsKey('bucketHash') && item['bucketHash'] == 215593132) {
            print('entro en postmaster');
            postmasterlist.add(item);
          }
        } else {
          print('entro en armas no equipadas!');
          unequippedItems.add(item);
        }
      });

      // Aquí debes llamar a la función postmaster
      Future<List<Transferencia>> transferencias = postmaster(postmasterlist);
      print('Número de transferencias: ${transferencias}'); // Agrega este mensaje de depuración

      return transferencias;
    } else {
      print('No se encontraron armas no equipadas');
      return [];
    }


  }

  Future<List> actualizarpostmster() async {
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
          userMap?['Response']?['characterInventories']?['data']?['2305843009260605642']?['items'] ?? [];

      print(characterEquipment);
      List<dynamic> equippedItems = [];
      List<dynamic> unequippedItems = [];
      List<dynamic> postmasterlist = [];

      characterEquipment.forEach((item) {
        if (item?['isEquipped'] != true) {
          print('entro');
          equippedItems.add(item);
          if (item.containsKey('bucketHash') && item['bucketHash'] == 215593132) {
            print('entro en postmaster');
            postmasterlist.add(item);
          }
        } else {
          print('entro en armas no equipadas!');
          unequippedItems.add(item);
        }
      });

      // Aquí debes llamar a la función postmaster
      Future<List<Transferencia>> transferencias = postmaster(postmasterlist);
      print('Número de transferencias: ${transferencias}'); // Agrega este mensaje de depuración

      return postmasterlist;
    } else {
      print('No se encontraron armas no equipadas');
      return [];
    }


  }

  List<Transferencia>erismorn(postmasterlist){
    List <Transferencia> nuevo=[];
    return nuevo;
  }


  Future<List<Transferencia>> postmaster(List<dynamic> postmasterlist) async{
    List<Transferencia> transferencias = [];

    // Agregar información de depuración
    print('Número de elementos en postmasterlist: ${postmasterlist.length}');

    for (var i = 0; i < postmasterlist.length; i++) {
      print(postmasterlist[i]);
      // Obtener el hash y el id del item
      var itemHash = postmasterlist[i]['itemHash'].toString();
      var itemInstanceId = (postmasterlist[i]['itemInstanceId'].toString());
      var nombre = postmasterlist[i]['itemName'].toString();
      String icon = 'https://www.bungie.net/${postmasterlist[i]['icon']}';
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
      var transferencia = Transferencia(
        itemName: itemName,
        itemInstanceId: itemInstanceId,
        characterId: '2305843009260605642',
        membershipType: 1,
        itemReferenceHash: int.parse(itemHash),
        stackSize: 1,
        transferToVault: true,
        icon: itemIcon,
      );

      transferencias.add(transferencia);

    }

    print('Número de transferencias creadas: ${transferencias.length}');
    return transferencias;
    }



  // Future<void> _actualizarTransferencias() async {
  //   List<Transferencia> nuevasTransferencias = await postmaster(postmasterlist);
  //
  //   setState(() {
  //     _transferencias = nuevasTransferencias;
  //   });
  // }




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
            'https://www.bungie.net/Platform/Destiny2/Actions/Items/PullFromPostmaster/'));
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
      // Llama a postmaster de manera asincrónica y espera su finalización
      List<Transferencia> nuevasTransferencias = await postmaster(postmasterlist);

      // Actualiza postmasterlist con las nuevas transferencias
      postmasterlist = nuevasTransferencias;

      setState(() {
        _transferencias = Future.value(nuevasTransferencias);
      });
      return "tranferencia existosa";
    } else {
      return "Fallo en la transferencia.";
    }

  }






  //do a class to control statefullwidget
  @override
  void initState() {
    super.initState();

    List<dynamic> postmasterlist = [];
    _transferencias = calltoapi()!;

  }

  @override
  void dispose() {
    super.dispose();
  }




}

