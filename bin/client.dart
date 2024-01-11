import 'dart:io';

class ClientIO {
  Future<void> connect() async {
    final socket = await Socket.connect("localhost", 8523);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
    socket.listen((event) {
      final serverResponse = String.fromCharCodes(event);
      print('client: $serverResponse');
    });
  }
}
