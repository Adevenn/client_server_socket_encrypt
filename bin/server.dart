import 'dart:io';

import 'rsa_encryption.dart';
import 'salsa_20_encryption.dart';

class ServerIO {
  static const port = 8523;
  final salsa20 = Salsa20Encryption();

  void start() async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    server.listen(cancelOnError: true, (Socket client) {
      handleConnection(client);
    });
  }

  void handleConnection(Socket s) {
    print('Connection from ${s.remoteAddress.address}:${s.remotePort}');
    RSAEncryption rsa;
    s.listen((event) {
      var response = String.fromCharCodes(event);
      print('Server public key : $response');
      rsa = RSAEncryption.fromClient(response);
      print('Server salsaKey : ${salsa20.key.base64}');
      s.write(rsa.encrypt(salsa20.key.base64));
    });
  }
}
