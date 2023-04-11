import 'package:flutter/material.dart';
import 'package:folderdocker/main.dart';

import '../folderes/transerencia.dart';

class TransferenciaScreen extends StatefulWidget {
  @override
  _TransferenciaScreenState createState() => _TransferenciaScreenState();
}

class _TransferenciaScreenState extends State<TransferenciaScreen> {
  late Future<List<Transferencia>> _transferencias;

  @override
  void initState() {
    super.initState();
    _transferencias = calltoapi();
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
                    'https://th.bing.com/th/id/OIP.BszFeHpWQrTyMTNSFOxLNwHaEo?pid=ImgDet&rs=1')
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
}
