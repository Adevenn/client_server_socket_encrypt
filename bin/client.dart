import 'dart:convert';
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
    s.write(rsa.pemPublicKey());
    s.listen((event) {
      final json = jsonDecode(rsa.decrypt(String.fromCharCodes(event)));
      salsa20 = Salsa20Encryption(json['key'], json['iv']);
      start();
    });
  }

  Future<void> sendRequest(String request, Object data) async{
    final s = await Socket.connect("localhost", 8522);
    s.write(salsa20.encrypt('Hi server'));
    s.listen((event) {
      var response = salsa20.decrypt(String.fromCharCodes(event));
      print('Server response : ${String.fromCharCodes(event)}');
      print('Server response decrypted : $response');
    });
  }

  void start() async {
    sendRequest('hi', '');
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
