import 'dart:io';

import 'rsa_encryption.dart';
import 'salsa_20_encryption.dart';

class ClientIO {
  late final Salsa20Encryption salsa20;

  Future<void> connect() async {
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
}
