import 'dart:io';

import 'Encryption/salsa_20_encryption.dart';

class ServerIO{
  static const port = 8522;
  List<Socket> clients = [];
  final Salsa20Encryption salsa20;

  ServerIO(this.salsa20);

  void start() async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    server.listen(cancelOnError: true, (Socket s) {
      print('Connection from ${s.remoteAddress.address}:${s.remotePort}');
      s.listen((event) {
        var response = String.fromCharCodes(event);
        s.write(salsa20.encrypt('Hi client, you re registered'));
        print('Client request : $response');
        print('Client request decrypted : ${salsa20.decrypt(response)}');
      }, onError: (_){
        print(_);
        s.close();
      }, onDone: (){
        print('Connection done : From ${s.remoteAddress.address}');
        s.close();
      });
    });
  }

  Future<void> sendData() async{

  }
}