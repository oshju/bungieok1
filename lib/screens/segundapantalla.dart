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
      ),
      body: FutureBuilder(
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                Transferencia transferencia = snapshot.data![index];
                return ListTile(
                  title: Text(transferencia.itemName),
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
                );
              },
            );
          } else {
            return Center(
              child: Text("No hay datos disponibles"),
            );
          }
        },
      ),
    );
  }
}
