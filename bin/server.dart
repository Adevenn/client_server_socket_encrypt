import 'dart:io';

class ServerIO {
  static const port = 8523;

  void start() async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    server.listen((Socket client) {
      handleConnection(client);
    });
  }

  void handleConnection(Socket client) {
    print(
        'Connection from ${client.remoteAddress.address}:${client.remotePort}');
    client.write('Hello world');
    client.close();
  }
}
