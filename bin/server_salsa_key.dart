import 'dart:convert';
import 'dart:io';

import 'Encryption/rsa_encryption.dart';
import 'Encryption/salsa_20_encryption.dart';

class ServerSalsaKey {
  static const port = 8523;
  final Salsa20Encryption salsa;

  ServerSalsaKey(this.salsa);

  void start() async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    server.listen(
        cancelOnError: true,
        (Socket s) => s.listen((event) {
              var rsa = RSAEncryption.fromClient(String.fromCharCodes(event));
              s.write(rsa.encrypt(jsonEncode(
                  {'key': salsa.key.base64, 'iv': salsa.iv.base64})));
            }, onError: () => s.close(), onDone: () => s.close()));
  }
}
