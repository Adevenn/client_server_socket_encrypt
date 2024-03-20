import 'dart:io';

import 'Encryption/rsa_encryption.dart';
import 'Encryption/salsa_20_encryption.dart';

class ServerSalsaKey {
  static const port = 8523;
  final Salsa20Encryption salsa20;

  ServerSalsaKey(this.salsa20);

  void start() async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    server.listen(cancelOnError: true, (Socket s) {
      print('Connection from ${s.remoteAddress.address}:${s.remotePort}');
      RSAEncryption rsa;
      s.listen((event) {
        var response = String.fromCharCodes(event);
        print('Server public key : $response');
        rsa = RSAEncryption.fromClient(response);
        print('Server salsaKey : ${salsa20.key.base64}');
        s.write(rsa.encrypt(salsa20.key.base64));
      });
    });
  }
}
