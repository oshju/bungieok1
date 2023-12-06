import 'package:appwrite/models.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(appwrite());
}

class appwrite extends StatefulWidget {
  @override
  _AppwriteAppState createState() => _AppwriteAppState();
}

class _AppwriteAppState extends State<appwrite> {
  TextEditingController _textoController = TextEditingController();
  TextEditingController _textoController1 = TextEditingController();
  List<String> items = ['https://e00-elmundo.uecdn.es/assets/multimedia/imagenes/2021/08/09/16285263423187.jpg', 'https://i.blogs.es/adc42f/invasion/1366_2000.jpeg', 'Item 3'];
  List<String> items2 = ['https://sm.ign.com/ign_es/screenshot/default/mario-critica_a8nu.jpg', 'https://media.vandalsports.com/i/640x360/7-2023/202372492559_1.jpg', 'Item 3'];
  List<String> items3 = ['https://phantom-marca.unidadeditorial.es/fe5d6a51abd88257e4f858b87d9430b8/resize/828/f/jpg/assets/multimedia/imagenes/2023/04/24/16823273948259.jpg', 'https://imagenes.20minutos.es/files/og_thumbnail_1900/uploads/imagenes/2021/06/17/scarlett-johansson-como-viuda-negra.jpeg',
    'https://image.europafm.com/clipping/cmsimages01/2021/07/30/251DC050-0EF8-4D77-AFD1-AC364A3F7960/98.jpg?crop=1400,788,x0,y0&width=1900&height=1069&optimize=low&format=webply'];
  List<String> items4 = ['Item 1', 'Item 2', 'Item 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appwrite App'),
      ),
      body: ListView(
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
          _buildTextField(controller: _textoController1, labelText: "hola"),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              String textoIngresado = _textoController.text;
              String textoIngresado1 = _textoController1.text;
              mostrarSnackBar(context,
                  '¡Acción exitosa! Texto ingresado: $textoIngresado');
              await ejemplo();
              await subir(textoIngresado, textoIngresado1);

              // Agregar más elementos a las listas
              setState(() {
                items.add('Nuevo Item ${items.length + 1}');
                items2.add('Nuevo Item ${items2.length + 1}');
                items3.add('Nuevo Item ${items3.length + 1}');
                items4.add('Nuevo Item ${items4.length + 1}');
              });
            },
            child: Text('Realizar Acción'),
          ),
          SizedBox(height: 16),
          // Carrusel 1
          _buildCarousel(items),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Series',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontFamily: 'TuFuente',
              ),
            ),
          ),
          SizedBox(height: 16), // Ajusta el espacio entre carruseles
          // Carrusel 2
          _buildCarousel(items2),
          SizedBox(height: 16), // Ajusta el espacio entre carruseles
          // Carrusel 3
          _buildCarousel(items3),
          SizedBox(height: 16), // Ajusta el espacio entre carruseles
          // Carrusel 4
          _buildCarousel(items4),
        ],
      ),
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 18,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          labelStyle: TextStyle(
            fontSize: 18,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String> items) {
    return CarouselSlider.builder(
      itemCount: items.length,
      itemBuilder: (context, index, realIndex) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 120,
          margin: EdgeInsets.only(right: 10.0), // Ajusta el espacio entre imágenes
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              items[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        aspectRatio: 16 / 9,
        enlargeCenterPage: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
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
    _textoController1.dispose();
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




















