import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SnackBar Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textoController,
              decoration: InputDecoration(
                labelText: 'Ingrese un texto',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String textoIngresado = _textoController.text;
                mostrarSnackBar(context, '¡Acción exitosa! Texto ingresado: $textoIngresado');
                subir(textoIngresado); // Pasa el valor del texto a la función subir
              },
              child: Text('Realizar Acción'),
            ),
          ],
        ),
      ),
    );
  }

  void mostrarSnackBar(BuildContext context, String mensaje) {
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void subir(String texto) {
    // Aquí puedes utilizar el valor del texto como desees
    print('Texto ingresado en subir: $texto');
    // Llamar a tus funciones o realizar acciones necesarias con el texto
  }

  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }
}

Future<Map<dynamic, String>> subir(String textoIngresado) async {
  try {
    // Configurar el cliente Appwrite
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1') // Reemplaza con tu URL de Appwrite
        .setProject('6550c358e8cde42e540e');
    // Eliminar en producción

    // Crear una cuenta y obtener una sesión
    final account = Account(client);
    await account.create(
      userId: textoIngresado,
      email: 'me@appwrite.io',
      password: 'password12',
      name: 'My Name',
    );
    //await account.createAnonymousSession();
    await account.createEmailSession(email: 'me@appwrite.io', password: 'password12');

    // Obtener el perfil del usuario
    await account.get();
    final profile = await account.get();

// Extraer el nombre del perfil
    String nombreUsuario = profile.toString(); // Ajusta la clave según la estructura de tu perfil
    print('Nombre del usuario: $nombreUsuario');

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
    //mostrarSnackBar(context, '¡Acción exitosa!');
  } catch (e) {
    print('Error: $e');
    return {'status': 'error'};
  }
}