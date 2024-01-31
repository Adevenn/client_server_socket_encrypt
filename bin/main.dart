import 'encryption.dart';

const String version = '0.0.1';

///This project works with 3 packages :
///
/// - pointycastle
///
/// - asn1lib
///
/// - encrypt
void main(List<String> arguments) {
  final encryption = Encryption.demo();

  /*final server = ServerIO();
  server.start();
  final client = ClientIO();
  client.connect();*/
}
