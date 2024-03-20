import 'dart:io';

import 'Encryption/rsa_encryption.dart';
import 'Encryption/salsa_20_encryption.dart';

class ClientIO {
  static const playerPort = 8524;
  late final Salsa20Encryption salsa20;

  Future<void> getSalsaKey() async {
    final rsa = RSAEncryption();
    final s = await Socket.connect("localhost", 8523);
    print('Connected to: ${s.remoteAddress.address}:${s.remotePort}');
    print('Client PEM : ${rsa.pemPublicKey()}');
    s.write(rsa.pemPublicKey());
    s.listen((event) {
      final salsaKey = rsa.decrypt(String.fromCharCodes(event));
      print('Client salsaKey : $salsaKey');
      salsa20 = Salsa20Encryption(salsaKey);
    });
  }

  void start() async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, playerPort);
    server.listen(cancelOnError: true, (Socket client) {
      handleConnection(client);
    });
  }

  void handleConnection(Socket s) {
    print('Connection from ${s.remoteAddress.address}:${s.remotePort}');
    s.listen((event) {
      var response = String.fromCharCodes(event);
    });
  }
}
