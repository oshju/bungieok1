import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late oauth2.Client? client;
  final authorizationEndpoint = Uri.parse('https://www.bungie.net/en/OAuth/Authorize');
  final tokenEndpoint = Uri.parse('https://www.bungie.net/platform/app/oauth/token/');
  final identifier = '37130';
  final secret = '';
  final redirectUrl = Uri.parse('com.example.ui:/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OAuth2 Authorization Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                // Iniciar el proceso de autorización
                client = await authorize();
              },
              child: Text('Iniciar Autorización OAuth2'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Usar el cliente autorizado para hacer una solicitud
                if (client != null) {
                  final response = await client!.read(Uri.https('https://www.bungie.net/Platform/Destiny2/1/Profile/4611686018429892101/?components=100,102,103,104,200,201,202,204,205,300,301,302,303,304,305,306,307,308,309,310,700,800,900,1000,1100,1200,1400'));
                  print(response);
                } else {
                  print('Cliente no autorizado.');
                }
              },
              child: Text('Hacer Solicitud con Cliente Autorizado'),
            ),
          ],
        ),
      ),
    );
  }

  Future<oauth2.Client> authorize() async {
    final grant = oauth2.AuthorizationCodeGrant(
      identifier,
      authorizationEndpoint,
      tokenEndpoint,
      secret: secret,
    );

    final authorizationUrl = grant.getAuthorizationUrl(redirectUrl);

    // Abre la URL de autorización en un navegador externo
    final urlString = authorizationUrl.toString();
    if (await canLaunch(urlString)) {
      await launch(urlString);
    } else {
      print('No se pudo abrir la URL en el navegador externo.');
    }

    // Espera la URL de redirección
    final responseUrl = await listen(redirectUrl);
    print(responseUrl);
    // Maneja la respuesta de autorización y devuelve un cliente autorizado
    final client = await grant.handleAuthorizationResponse(responseUrl.queryParameters);
    print(client);
    return client;
  }

  Future<Uri> listen(Uri redirectUrl) async {
    final responseCompleter = Completer<Uri>();
    final streamSubscription = StreamController<Uri>.broadcast();

    void handleRedirection(Uri url) {
      print('Received URL: $url');
      if (url.toString().startsWith(redirectUrl.toString())) {
        responseCompleter.complete(url);
        print('URL matches redirectUrl. Completing with URL: $url');
      }
    }

    streamSubscription.stream.listen(handleRedirection);

    void closeStream() {
      streamSubscription.close();
      print('Stream closed.');
    }

    print('Start redirect');
    redirect(redirectUrl);
    print('Redirect started with URL: $redirectUrl');

    try {
      final responseUrl = await responseCompleter.future;
      print('Received response URL: $responseUrl');
      return responseUrl;
    } catch (e) {
      print('Error in listen: $e');
      return Uri(); // Puedes cambiar esto a un manejo de error apropiado.
    } finally {
      closeStream();
    }
  }

  Future<void> redirect(Uri url) async {
    // Abre la URL en un navegador externo
    final urlString = url.toString();
    if (await canLaunch(urlString)) {
      await launch(urlString);
    } else {
      print('No se pudo abrir la URL en el navegador externo.');
    }
  }
}
