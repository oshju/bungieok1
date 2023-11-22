import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(appwrite());
}

class appwrite extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<appwrite> {
  TextEditingController _textoController = TextEditingController();
  TextEditingController _textoController1 = TextEditingController();
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
            TextField(
              controller: _textoController1,
              decoration: InputDecoration(
                labelText: 'Ingrese un correo',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String textoIngresado = _textoController.text;
                String textoIngresado1=_textoController1.text;
                mostrarSnackBar(context, '¡Acción exitosa! Texto ingresado: $textoIngresado');
                 // Pasa el valor del texto a la función subir
               await ejemplo();
               await subir(textoIngresado,textoIngresado1);
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



  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }
}

Future<Map<dynamic, String>> subir(String textoIngresado,String textoIngresado1) async {
  try {
    // Configurar el cliente Appwrite
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1') // Reemplaza con tu URL de Appwrite
        .setProject('6550c358e8cde42e540e');
    // Eliminar en producción

    // Crear una cuenta y obtener una sesión
    final account = Account(client);
    if(account.get()!=textoIngresado)
    await account.create(
      userId: textoIngresado,
      email: textoIngresado1,
      password: 'password12',
      name: 'My Name',
    );
    //await account.createAnonymousSession();
    bool esVerdadero = true;
    bool? metodo = await verificarUsuario(textoIngresado);
    if(metodo== false){
      await account.createEmailSession(email: textoIngresado1, password: 'password12');
    }




    // Obtener el perfil del usuario
    await account.get();
    final profile = await account.get();
    //hola

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


Future<void> ejemplo() async {
  try {
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('6550c358e8cde42e540e');

    final account = Account(client);
    final databases = Databases(client);
    // Ejemplo: Obtener información del usuario
    DocumentList userlist = await databases.listDocuments(
      collectionId: '6550c68382b5408d115b',
      databaseId: '6550c6665be761eef4d1',
    );



    print(userlist);
    final String searchKey='oscar';
    Query.search("title", searchKey!);
    // Process the list of users
    for (var user in userlist.documents) {
      print('entro');
      var userData = user.data;
      print(userData);
      // Aquí puedes acceder a las propiedades del documento 'user'
    }



  } catch (e) {
    print('Error fetching users: $e');
  }
}





Future<bool?> verificarUsuario(String textoIngresado1) async {
  try {
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1') // Reemplaza con tu URL de Appwrite
        .setProject('6550c358e8cde42e540e'); // Reemplaza con tu ID de proyecto

    final account = Account(client);

    // Obtener la lista de identidades
    final identidades = await account.listIdentities();

    // Verificar si el usuario con el correo específico ya existe
    bool usuarioExiste = identidades.identities.any((identidad) => identidad.providerEmail == textoIngresado1);

    if (usuarioExiste) {
      print('El usuario con el correo $textoIngresado1 ya existe.');
      return true;
    } else {
      print('El usuario con el correo $textoIngresado1 no existe.');
      return false;
    }

  } catch (e) {
    print('Error al verificar usuario: $e');
    return null;
  }
}




















