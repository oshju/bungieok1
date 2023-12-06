import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';

void main() {
  runApp(CredenScreen());
}

class CredenScreen extends StatefulWidget {
  @override
  _CredenScreenState createState() => _CredenScreenState();
}

class _CredenScreenState extends State<CredenScreen> {
  String clientInfo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creden Screen'),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Información del Cliente:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                clientInfo,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await obtainAndShowClientInfo();
                },
                child: Text('Obtener Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> obtainAndShowClientInfo() async {
    try {
      final accountCredentials = ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "miercolesfiesta",
        "private_key_id": "b7a778cf4c39ae27ec76a6cf5d4c0d7f8ab7944a",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDW/fc/+BxQWYRm\nxIs9xGKV1j6ZjV8Q5zmxJCqqlWxxd3lMmPt7u0YFCUFvIKLRoCbHhiq/CqbnjP9F\nxcSOgGEESpQ0ZwSlHNTy2GlY4iXs9icYDATLEKgHDWSsgQRHoL4HisJbNLuWNtTQ\nwKYsfgr1vu73VNYw/y2b+t04C/ooq07yOHDvjNoZb2SMXmcsJodAa9tQwBsTDnPr\nw3fI0dC80cJguB7ELL1TF3plJfhNqgiVNWdqbLofzo6TjRm59EB/ENk2Gj3JyV4X\nZSqXKXpqY/M95kApwd8i91s5Q1oCLJ+zHiSDq3Uw4CrXPA5LHEoJZpEgxUtGZMSH\nkOy31ORVAgMBAAECggEAYsATjgPySWvct3GGvY/TcpyOc2xuoq56nuWMXX816OZm\nRmssdDhgYJbQQfF9KAlGVrZHMyn64PewF0XQU14fcd+ptGovRYH5RDRoKyXxIqcr\n7M00dGuJqneZ6ux14UqxjnhLbqZJlaVI2jvq+BvK//a7/8oteiLzuaYgb4p81KmH\nlEwqlmSU0Qzyb8xSW27NZHigYHjYYEBolLqte/ZAqzLqVFZwzUySYM6PuToafUSp\nSpyooKyaWPiDl4u1JWLdqT40tQet5tzQutkBlP15kdkoFS6Q/qLW4QMaoii4A0kX\nFU0Gi9px2enGNRenb+LF0JERJkUYi3UBrGDYamw2zwKBgQDuquczTx7a5OcYWfj3\nJORi4ZKyIjWcUUiOx/KEBvqIpDhxnnL0g/udPD8KH8tmhJwBtEL5Mil3UqRDHHH5\neWJVcmGbTnwCOa77BGrgxnIzd+K5KAM2ny+7IaOqleSnODHZGH3NjGglbEcjvWmI\nLmmuVd2XhVzoYT4xn/QNmNA2AwKBgQDmmuh14/XwszW6z1YSxK5oQgBp5O4qo+qV\nfe8QYroi6ESzsPQDBLsnCuJ8cTzBghoyK/FAK6hN6Epwv1wpKwzA59qIg9jNXTdE\nSYoD9hD0SHBHSRcAS6C73gjIeBsMtpJrwgwGw1gqpeNDydyww9SZHPWW/iuLReHU\nEvEhIzj4xwKBgH+ZQ259GIPy6VJtl9uaD7iF3QX7oCnokyAy6geIK52uHrcv/UmY\n3obb1OA2y2oN79JBa6ULGnw+5K80oAK+0MHaGzELLuWJrXFqlTGDJz85Ey/mooEr\nbjtf6r6i0NJOCuiEXY3tSSjo0Mfc1nUGS133bjc6B8f9ZWDmoXY7guW9AoGAFAV7\nDVE/dyh4D8IUnQiKg+7HDmqb6wPUSCpo6SlJM+KqpFdGuERe42Lkix1hwwNCtvxt\ns76WnD0AyY0zuTdNoin/JT8dQadINxuTagihLDRl2yqTXqkySV1bsdwLrSzkxYpR\ndPzc2McSVj5edNJr0Odcw0FKEot8seb7HH9sYN0CgYEA0A4tiXu4JzVzi2aD4gC4\njlhd0jp6Ty/D4HiqfDppNWNeBdmzoCMdQKBK/BKbeiV3m/zsYYYiT/2C99Jvewj+\nmpJ4AQycppXKATLkbYtK9nk/KCHjsizrq9yqR6RakJ9j6BwFq8EmRKi9MNq1BZf9\nR6QKh/khSZj2R9pV0v0GmbI=\n-----END PRIVATE KEY-----\n",
        "client_email": "cuenta@miercolesfiesta.iam.gserviceaccount.com",
        "client_id": "113958610629844647627",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/cuenta%40miercolesfiesta.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      });
      var scopes = ['https://www.googleapis.com/auth/drive'];

      AuthClient client = await clientViaServiceAccount(accountCredentials, scopes);

      print('Token Bearer: ${client.credentials.accessToken}');

      String clientInfoString = '''
        Client ID: ${accountCredentials.clientId}
        Scopes: ${scopes.join(', ')}
        Token: ${client.credentials.accessToken}
      ''';


      setState(() {
        clientInfo = clientInfoString;
      });

      client.close();
    } catch (error) {
      print('Error: $error');
    }
  }
}
