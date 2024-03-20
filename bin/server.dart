import 'dart:io';

import 'Encryption/salsa_20_encryption.dart';

class ServerIO{
  static const port = 8522;
  final Salsa20Encryption salsa20;

  ServerIO(this.salsa20);

  void start() async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    server.listen(cancelOnError: true, (Socket s) {
      print('Connection from ${s.remoteAddress.address}:${s.remotePort}');
      s.listen((event) {
        var response = String.fromCharCodes(event);
      });
    });
  }
}