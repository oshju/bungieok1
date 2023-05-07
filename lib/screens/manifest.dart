import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:core';
import 'package:path/path.dart';



class Manifest extends StatefulWidget {
  @override
  _ManifestState createState() => _ManifestState();
}

class _ManifestState extends State<Manifest> {
  void initState() {
    super.initState();
    _downloadFile();
    BungieManifest.getDetails();
    BungieManifest.getMobileWorldContentPaths();
  }

  Future<void> _downloadFile() async {
    final manifest = await BungieManifest.initializeBungieManifest(
        '3028328cf7734aecb7217b2843daa5f0');
    if (manifest != null) {
      print('Bungie Manifest descargado');
    } else {
      print('Error al descargar el Bungie Manifest');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manifest'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class BungieManifest {
  static final String _baseUrl = 'https://www.bungie.net';
  static final String _manifestUrl = '$_baseUrl/platform/Destiny2/Manifest/';
  static final String _manifestFileName = 'manifest.json';
  static final String languageCode = 'en';

  static String? _apiKey = '3028328cf7734aecb7217b2843daa5f0';
  static String? _contentPath;
  static Map<String, dynamic>? _worldContentPaths;
  static const int _dbConnectionLimit = 1;

  static Future<Map<String, dynamic>?> initializeBungieManifest(
      String apiKey) async {
    _apiKey = apiKey;

    try {
      // Realizar solicitud GET al endpoint del Manifest con un timeout de 30 segundos
      final response =
      await _makeHttpRequest(_manifestUrl, {'X-API-Key': _apiKey!})
          .timeout(Duration(seconds: 3600));

      // Verificar que la solicitud fue exitosa
      if (response.statusCode != 200) {
        throw Exception(
            'Error al descargar el Bungie Manifest: ${response.statusCode}');
      }

      // Decodificar el JSON y extraer los paths del contenido
      final data = jsonDecode(response.body);
      _contentPath = data['Response']['mobileAssetContentPath'];
      _worldContentPaths = data['Response']['mobileWorldContentPaths'];

      return _worldContentPaths;
    } catch (e) {
      print('Error al descargar el Bungie Manifest: $e');
      return null;
    }
  }

  static Future<String?> getMobileAssetPath1(String version) async {
    if (_contentPath == null) {
      await initializeBungieManifest(_apiKey!);
    }

    Map<String, dynamic>? manifest = await initializeBungieManifest(_apiKey!);

    // Imprimimos el contenido del mapa manifest para verificar que esté completo
    print(manifest);

    // Aquí asumimos que el valor "en" está dentro del primer elemento del arreglo de "mobileWorldContentPaths"
    String? mobileAssetContentPath = manifest?["en"];

    // Si mobileAssetContentPath sigue siendo nulo, es posible que el problema esté aquí
    if (mobileAssetContentPath == null) {
      print('No se pudo obtener la ruta del contenido móvil');
      return null;
    }

    String contentUrl = 'https://www.bungie.net$mobileAssetContentPath';


    final response = await http
        .get(Uri.parse(contentUrl))
        .timeout(Duration(seconds: 36000));

    if (response.statusCode != 200) {
      throw Exception(
          'Error al descargar el Asset Content: ${response.statusCode}');
    }

    final dbDir = await getApplicationDocumentsDirectory();
    final dbPath = dbDir.path +
        '/world_sql_content_23e679d4eb3ea63e606ca90354808bd6.sqlite3';

    final file = File(dbPath);
    await file.writeAsBytes(response.bodyBytes);

    try {
      final db = await openDatabase(dbPath, version: 2,
          onOpen: (db) async {
            await db.execute('PRAGMA journal_mode = WAL');
          },
          onConfigure: _onConfigure,
          onCreate: (Database db, int version) async {
            try {
              // Borra la base de datos si ya existe
              await File(dbPath).delete();

              // Resto del código...
            } catch (e) {
              print('Error al abrir la base de datos: $e');
              return null;
            } finally {
              // Cierra la base de datos
              await db.close();
            }
          });

      try {
              // Obtiene el archivo de la base de datos desde los assets
              ByteData data = await rootBundle.load(join('assets', 'world_sql_content_23e679d4eb3ea63e606ca90354808bd6.content.db'));
              List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

              // Escribe los bytes del archivo a la ubicación de la base de datos
              await File(dbPath).writeAsBytes(bytes);

              // Inserta los datos del manifiesto en la base de datos
              if (manifest != null) {
                await db.transaction((txn) async {
                  for (final entry in manifest.entries) {
                    final id = entry.key;
                    final json = jsonEncode(entry.value);
                    await txn.rawInsert(
                        'INSERT INTO ManifestData (id, json) VALUES (?, ?)',
                        [id, json]);
                  }
                });
              }

              var hola = await db.rawQuery(
                  'SELECT json FROM DestinyInventoryItemDefinition WHERE json LIKE ?',
                  ['%"displayProperties":{"name":"The Last Word"}%']);
              print(hola);

            } catch (e) {
              print('Error al abrir la base de datos: $e');
              return null;
            } finally {
              // Cierra la base de datos
              await db.close();
            }













      // Inserta los datos del manifiesto en la base de datos
      if (manifest != null) {
        await db.transaction((txn) async {
          for (final entry in manifest.entries) {
            final id = entry.key;
            final json = jsonEncode(entry.value);
            await txn.rawInsert(
                'INSERT INTO ManifestData (id, json) VALUES (?, ?)',
                [id, json]);
          }
        });
      }

      var hola = await db.rawQuery(
          'SELECT json FROM DestinyInventoryItemDefinition WHERE json LIKE ?',
          ['%"displayProperties":{"name":"The Last Word"}%']);
      print(hola);

      // Cierra la base de datos
      await db.close();
    } on DatabaseException catch (e) {
      print('Error al abrir la base de datos: $e');

      return null;
    } catch (e) {
      print('Error al interactuar con la base de datos: $e');
      return null;
    }
  }



  static Future<Map<String, dynamic>?> getMobileWorldContentPaths() async {
    if (_worldContentPaths == null) {
      await initializeBungieManifest(_apiKey!);
    }

    final path = await getMobileAssetPath1('1.0.0');
    final pathString = path?.toString();

    final langPath =
    pathString?.replaceAll('.content', '_$languageCode.content');
    final worldContentUrl = '$_baseUrl$langPath';

    final response = await http.get(Uri.parse(worldContentUrl));

    if (response.statusCode == 200) {
      // Decodificar el archivo ZIP
      final bytes = response.bodyBytes;
      final archive = ZipDecoder().decodeBytes(bytes);

      // Buscar y decodificar el archivo json
      final contentFile =
      archive.firstWhere((file) => file.name.endsWith('.json'));
      final contentJson = contentFile.content as Uint8List;
      final contentString = utf8.decode(contentJson);
      final contentMap = json.decode(contentString);
      print(contentMap);
      print('realizado');
      return contentMap;
    } else {
      throw Exception(
          'Error al descargar el World Content: ${response.statusCode}');
    }
  }

  static Future<String> getMobileAssetPath(String apiKey) async {
    Map<String, dynamic>? manifest = await initializeBungieManifest(apiKey);
    if (manifest == null) {
      throw Exception("No se pudo obtener el manifiesto de Bungie");
    }
    //String? displayName = definition?['displayProperties']?['name']?['en'];
    String mobileAssetContentPath = manifest!['jsonWorldContentPaths']['en'];

    String url = 'https://www.bungie.net$mobileAssetContentPath';
    return url;
  }

  static Future<http.Response> _makeHttpRequest(
      String url, Map<String, String> headers) async {
    final response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }

  static Future<List> getDetails() async {
    Map<String, dynamic>? worldContentPaths;
    Map<String, dynamic>? inventoryItemDefinitions;

// Obtener las rutas de los archivos que contienen las definiciones del contenido
    worldContentPaths = await BungieManifest.getMobileWorldContentPaths();
    final String? itemDefinitionPath =
    worldContentPaths?['DestinyInventoryItemDefinition'];

// Descargar el archivo de definiciones de contenido
    final String? itemDefinitionFilePath =
    await BungieManifest.getMobileAssetPath1(itemDefinitionPath!);

// Cargar las definiciones de contenido desde el archivo descargado
    final String itemDefinitionFile =
    File(itemDefinitionFilePath!).readAsStringSync();
    inventoryItemDefinitions = jsonDecode(itemDefinitionFile)['items'];

// Buscar la entrada de la arma en las definiciones de contenido
    final int itemHash = 1403800851; // reemplazar con el hash único de la arma
    final Map<String, dynamic>? itemDefinition =
    inventoryItemDefinitions![itemHash.toString()];

// Obtener las estadísticas de la arma
    final List<dynamic>? stats = itemDefinition?['stats'];
    if (stats != null) {
      for (final stat in stats) {
        final int statHash = stat['statHash'];
        final String statName = inventoryItemDefinitions![statHash.toString()]
        ?['displayProperties']['name'];
        final int statValue = stat['value'];
        print('$statName: $statValue');
      }
    }
    return stats!;
  }

  static Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA journal_mode = WAL');
    await db.execute('PRAGMA busy_timeout = 5000');
    await db.execute('PRAGMA foreign_keys = ON');
    // Aquí establecemos el límite de conexiones a la base de datos.
    await db.execute('PRAGMA max_connections = $_dbConnectionLimit');
  }
}
